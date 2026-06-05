# Notificações Push (FCM) — Guia de configuração

A app já tem todo o código pronto. Falta só ligar o Firebase e o Supabase.
Faz estes passos pela ordem. (Android primeiro; iOS no fim.)

> Enquanto não fizeres isto, a app funciona na mesma — só com notificações
> locais (app aberta). O código de push fica inativo sem rebentar nada.

---

## 1. Criar o projeto Firebase  *(só tu podes fazer)*

1. Vai a https://console.firebase.google.com → **Adicionar projeto** (ex.: "GGPEN App").
2. Dentro do projeto: **Adicionar app → Android**.
   - **Nome do pacote Android:** `ggpen.app`  ← tem de ser exatamente este.
   - Regista a app.
3. Faz **download do `google-services.json`**.
4. Coloca o ficheiro em: `android/app/google-services.json`

## 2. Ativar o plugin Google Services no Gradle

No `android/settings.gradle.kts`, no bloco `plugins { ... }`, adiciona:
```kotlin
id("com.google.gms.google-services") version "4.4.2" apply false
```

No `android/app/build.gradle.kts`, no topo, no bloco `plugins { ... }`, adiciona:
```kotlin
id("com.google.gms.google-services")
```
(Diz-me quando o `google-services.json` estiver no sítio que eu faço esta parte.)

## 3. Tabela de tokens no Supabase

No **SQL Editor** corre o ficheiro: `doc/fcm_device_tokens.sql`

## 4. Conta de serviço do Firebase (para o servidor enviar push)

1. Firebase Console → ⚙️ **Definições do projeto** → separador **Contas de serviço**.
2. **Gerar nova chave privada** → faz download do JSON.
3. No Supabase, guarda-o como secret (numa linha):
   ```bash
   supabase secrets set FCM_SERVICE_ACCOUNT="$(cat caminho/para/serviceAccount.json)"
   ```

## 5. Deploy da Edge Function

```bash
supabase functions deploy notify-activity-change --no-verify-jwt
```
(A função está em `supabase/functions/notify-activity-change/index.ts`.)

## 6. Webhook: chamar a função quando uma atividade muda

Supabase → **Database → Webhooks → Create a new hook**:
- **Table:** `activities`
- **Events:** `Update` (e `Insert`, se quiseres avisar de novas sessões)
- **Type:** Supabase Edge Function → `notify-activity-change`
- Método `POST`. Guarda.

## 7. Testar

1. Instala o novo APK no telemóvel e abre a app uma vez (regista o token).
2. No painel admin, muda o horário de uma atividade.
3. O telemóvel recebe o push — **mesmo com a app fechada**.

---

## iOS (opcional, mais tarde)

Precisa de:
- Conta **Apple Developer** (paga, 99 USD/ano).
- Adicionar app **iOS** no Firebase (bundle id) e baixar `GoogleService-Info.plist` para `ios/Runner/`.
- Criar **chave APNs** no Apple Developer e carregá-la no Firebase (Cloud Messaging).
- Ativar capability **Push Notifications** + **Background Modes (Remote notifications)** no Xcode.

Diz-me quando chegares a esta fase que eu trato da parte do código/Xcode.

---

### Como funciona (resumo)
```
Admin muda horário  →  Webhook do Supabase  →  Edge Function
   → lê device_tokens → envia FCM v1 → telemóveis (app aberta OU fechada)
   → "⏰ Horário alterado: Sessão X — Agora às 15:00"
```
A app, com a app aberta, mostra na hora; fechada, o sistema entrega o push.
Tokens inválidos são limpos automaticamente.
