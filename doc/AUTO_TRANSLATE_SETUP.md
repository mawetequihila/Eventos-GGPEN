# Tradução automática do conteúdo (PT → EN/FR/AR) — SEM cartão

Objetivo: o admin escreve **só em português** e a app mostra as 4 línguas.
Uma Edge Function traduz e preenche as colunas `_en/_fr/_ar` automaticamente.

Usa o **MyMemory** — tradução gratuita, **sem chave e sem cartão de crédito**.
A app já está pronta para ler essas colunas (não precisa de mais nada).

---

## 1. Colunas na base de dados
Corre, se ainda não correste: `doc/i18n_content.sql`
(cria `titulo_en/fr/ar`, `descricao_en/fr/ar`, `organizacao_en/fr/ar`, `bio_en/fr/ar`).

## 2. Login no Supabase CLI
```bash
supabase login
```

## 3. Deploy da Edge Function
```bash
cd ~/Documents/Project/GGPEN/Eventos-GGPEN
supabase functions deploy translate-content --project-ref qufggxgghnlcbncnxhda --no-verify-jwt
```

## 4. (OPCIONAL) Aumentar o limite diário — só um email, sem cartão
O MyMemory dá mais traduções/dia se enviares um email (anónimo é mais limitado):
```bash
supabase secrets set MYMEMORY_EMAIL="o_teu_email@exemplo.com" --project-ref qufggxgghnlcbncnxhda
```

## 5. Criar os Webhooks (disparam a tradução ao gravar)
Supabase → **Database → Webhooks → Create a new hook** (cria DOIS):

**Hook 1 — Atividades**
- Table: `activities`
- Events: `Insert`, `Update`
- Type: **Supabase Edge Function** → `translate-content`

**Hook 2 — Convidados**
- Table: `speakers`
- Events: `Insert`, `Update`
- Type: **Supabase Edge Function** → `translate-content`

## 6. Testar
1. No painel, cria/edita uma atividade (em português) e guarda.
2. Segundos depois, as colunas `titulo_en/fr/ar` e `descricao_en/fr/ar` ficam preenchidas.
3. Abre a app, muda o idioma → o conteúdo aparece traduzido.

---

## Como se comporta
- **Escreves só PT.** Ao gravar, traduz para EN/FR/AR e guarda nas colunas.
- **Não traduz nomes, siglas nem locais** (esses campos não entram na tradução).
- **Correções manuais:** se editares uma tradução à mão, fica — só é reescrita se
  mudares o texto **português** dessa linha.
- **Re-traduzir tudo:** limpa as colunas `_en/_fr/_ar` dessa linha e grava de novo.
- **Sem loop:** a gravação de volta não dispara nova tradução.

## Limites do MyMemory (gratuito)
- Anónimo: ~5.000 palavras/dia. Com email (passo 4): ~50.000 palavras/dia.
- Para um evento (dezenas de atividades/oradores) chega bem. Se um dia esgotar,
  o que falhar fica em português e volta a tentar no dia seguinte ao gravares.
- Qualidade boa para PT/EN/FR; árabe razoável (podes sempre corrigir à mão um ou
  outro campo no painel).

## Reprocessar conteúdo já existente (uma vez)
```sql
update public.activities set titulo = titulo;   -- dispara o update -> traduz
update public.speakers    set nome   = nome;     -- idem
```
