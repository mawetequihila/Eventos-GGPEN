// Supabase Edge Function: translate-content
// Traduz automaticamente o conteúdo (PT → EN/FR/AR) e grava nas colunas _en/_fr/_ar.
// Acionada por Database Webhooks em `activities` e `speakers` (INSERT + UPDATE).
// O admin escreve só em português; a app mostra as 4 línguas.
//
// Usa o MyMemory (gratuito, SEM chave e SEM cartão).
// Secret OPCIONAL (aumenta o limite diário, basta um email):
//   MYMEMORY_EMAIL  -> o teu email
// (SUPABASE_URL e SUPABASE_SERVICE_ROLE_KEY já existem no ambiente da função.)
//
// Deploy:  supabase functions deploy translate-content --no-verify-jwt

import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const LANGS = ["en", "fr", "ar"] as const;

const FIELDS: Record<
  string,
  { base: string; cols: Record<string, string> }[]
> = {
  activities: [
    { base: "titulo", cols: { en: "titulo_en", fr: "titulo_fr", ar: "titulo_ar" } },
    { base: "descricao", cols: { en: "descricao_en", fr: "descricao_fr", ar: "descricao_ar" } },
  ],
  speakers: [
    { base: "organizacao", cols: { en: "organizacao_en", fr: "organizacao_fr", ar: "organizacao_ar" } },
    { base: "bio", cols: { en: "bio_en", fr: "bio_fr", ar: "bio_ar" } },
  ],
};

const EMAIL = Deno.env.get("MYMEMORY_EMAIL"); // opcional: aumenta o limite diário

// MyMemory limita ~500 caracteres por pedido → parte o texto em pedaços.
function splitChunks(text: string, max = 480): string[] {
  if (text.length <= max) return [text];
  const parts: string[] = [];
  let cur = "";
  for (const word of text.split(/\s+/)) {
    if ((cur + " " + word).trim().length > max) {
      if (cur.trim()) parts.push(cur.trim());
      cur = word;
    } else {
      cur += " " + word;
    }
  }
  if (cur.trim()) parts.push(cur.trim());
  return parts;
}

async function translate(text: string, target: string): Promise<string> {
  const out: string[] = [];
  for (const chunk of splitChunks(text)) {
    const params = new URLSearchParams({ q: chunk, langpair: `pt|${target}` });
    if (EMAIL) params.set("de", EMAIL);
    const res = await fetch(`https://api.mymemory.translated.net/get?${params}`);
    const json = await res.json();
    const t = json?.responseData?.translatedText;
    if (typeof t !== "string" || String(json?.responseStatus) !== "200") {
      throw new Error("MyMemory: " + JSON.stringify(json?.responseDetails ?? json));
    }
    out.push(t);
  }
  return out.join(" ");
}

Deno.serve(async (req) => {
  try {
    const payload = await req.json();
    const table = payload.table as string;
    const rec = payload.record ?? {};
    const old = payload.old_record ?? {};
    const fields = FIELDS[table];
    if (!fields || !rec.id) return new Response("ignorado", { status: 200 });

    const updates: Record<string, string> = {};
    for (const f of fields) {
      const base = (rec[f.base] ?? "").toString().trim();
      if (!base) continue;
      // Só (re)traduz se o texto base mudou OU se a tradução está vazia. Assim a
      // gravação de volta NÃO volta a disparar (evita loop) e respeita correções
      // manuais enquanto o PT não mudar.
      const baseChanged = (rec[f.base] ?? "") !== (old[f.base] ?? "");
      for (const lang of LANGS) {
        const col = f.cols[lang];
        const current = (rec[col] ?? "").toString().trim();
        if (baseChanged || !current) {
          try {
            updates[col] = await translate(base, lang);
          } catch (_) {
            // falha pontual numa língua — ignora, fica o fallback PT
          }
        }
      }
    }

    if (Object.keys(updates).length === 0) {
      return new Response("sem alterações", { status: 200 });
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );
    const { error } = await supabase.from(table).update(updates).eq("id", rec.id);
    if (error) throw error;

    return new Response(JSON.stringify({ table, id: rec.id, updated: Object.keys(updates) }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (e) {
    return new Response("erro: " + (e as Error).message, { status: 200 });
  }
});
