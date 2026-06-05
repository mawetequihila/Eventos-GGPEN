// Supabase Edge Function: notify-activity-change
// Recebe um Database Webhook (UPDATE/INSERT em `activities`), deteta o que mudou
// (horário ou local) e envia uma notificação PUSH (FCM HTTP v1) a todos os
// dispositivos registados em `device_tokens`.
//
// Secrets necessários (supabase secrets set ...):
//   FCM_SERVICE_ACCOUNT  -> JSON da conta de serviço do Firebase (uma linha)
// (SUPABASE_URL e SUPABASE_SERVICE_ROLE_KEY já existem no ambiente da função.)
//
// Deploy:  supabase functions deploy notify-activity-change --no-verify-jwt

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ---- Helpers de tempo (evento em Angola, UTC+1) ----------------------------
function hhmmLuanda(iso: string): string {
  const d = new Date(iso);
  const plus1 = new Date(d.getTime() + 60 * 60 * 1000); // UTC+1
  const h = String(plus1.getUTCHours()).padStart(2, "0");
  const m = String(plus1.getUTCMinutes()).padStart(2, "0");
  return `${h}:${m}`;
}

// ---- OAuth2 (service account -> access token) ------------------------------
function pemToDer(pem: string): Uint8Array {
  const b64 = pem
    .replace(/-----BEGIN PRIVATE KEY-----/, "")
    .replace(/-----END PRIVATE KEY-----/, "")
    .replace(/\s+/g, "");
  const raw = atob(b64);
  const der = new Uint8Array(raw.length);
  for (let i = 0; i < raw.length; i++) der[i] = raw.charCodeAt(i);
  return der;
}

function b64url(bytes: Uint8Array | string): string {
  const str = typeof bytes === "string"
    ? bytes
    : String.fromCharCode(...bytes);
  return btoa(str).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

async function getAccessToken(sa: any): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const header = { alg: "RS256", typ: "JWT" };
  const claim = {
    iss: sa.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: sa.token_uri,
    iat: now,
    exp: now + 3600,
  };
  const unsigned = `${b64url(JSON.stringify(header))}.${b64url(JSON.stringify(claim))}`;
  const key = await crypto.subtle.importKey(
    "pkcs8",
    pemToDer(sa.private_key),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  const sig = new Uint8Array(
    await crypto.subtle.sign("RSASSA-PKCS1-v1_5", key, new TextEncoder().encode(unsigned)),
  );
  const jwt = `${unsigned}.${b64url(sig)}`;

  const res = await fetch(sa.token_uri, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
  });
  const json = await res.json();
  if (!json.access_token) throw new Error("OAuth falhou: " + JSON.stringify(json));
  return json.access_token;
}

// ---- Handler ---------------------------------------------------------------
Deno.serve(async (req) => {
  try {
    const payload = await req.json();
    const rec = payload.record ?? {};
    const old = payload.old_record ?? {};

    // O que mudou?
    const timeChanged = rec.inicio !== old.inicio || rec.fim !== old.fim;
    const placeChanged = (rec.local ?? "") !== (old.local ?? "");
    if (payload.type === "UPDATE" && !timeChanged && !placeChanged) {
      return new Response("sem mudanças relevantes", { status: 200 });
    }

    const titulo = rec.titulo ?? "Sessão";
    const hora = rec.inicio ? hhmmLuanda(rec.inicio) : "";
    const local = rec.local ?? "";
    const title = timeChanged
      ? `Horário alterado: ${titulo}`
      : `Sessão atualizada: ${titulo}`;
    const body = `Agora às ${hora}${local ? " · " + local : ""}`;

    // Tokens dos dispositivos.
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );
    const { data: tokens, error } = await supabase
      .from("device_tokens")
      .select("token");
    if (error) throw error;
    if (!tokens?.length) return new Response("sem tokens", { status: 200 });

    // Access token FCM.
    const sa = JSON.parse(Deno.env.get("FCM_SERVICE_ACCOUNT")!);
    const accessToken = await getAccessToken(sa);
    const url = `https://fcm.googleapis.com/v1/projects/${sa.project_id}/messages:send`;

    let sent = 0;
    const stale: string[] = [];
    for (const { token } of tokens) {
      const r = await fetch(url, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          message: {
            token,
            notification: { title, body },
            android: { priority: "high" },
            data: { activityId: String(rec.id ?? ""), kind: timeChanged ? "time" : "update" },
          },
        }),
      });
      if (r.ok) {
        sent++;
      } else if (r.status === 404 || r.status === 400) {
        stale.push(token); // token inválido/expirado
      }
    }

    // Limpa tokens mortos.
    if (stale.length) {
      await supabase.from("device_tokens").delete().in("token", stale);
    }

    return new Response(JSON.stringify({ sent, removed: stale.length }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    return new Response("erro: " + (e as Error).message, { status: 500 });
  }
});
