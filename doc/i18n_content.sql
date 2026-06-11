-- ============================================================================
-- Conteúdo multilíngue (Opção A): colunas por idioma EN/FR/AR.
-- O texto base (titulo/descricao/organizacao/bio) continua em PORTUGUÊS e é o
-- fallback: se a tradução de um idioma estiver vazia, a app mostra o português.
-- A app escolhe a variante conforme o idioma selecionado.
-- Correr no SQL Editor do Supabase.
-- ============================================================================

-- ---- ATIVIDADES: título + descrição ----------------------------------------
alter table public.activities add column if not exists titulo_en text;
alter table public.activities add column if not exists titulo_fr text;
alter table public.activities add column if not exists titulo_ar text;
alter table public.activities add column if not exists descricao_en text;
alter table public.activities add column if not exists descricao_fr text;
alter table public.activities add column if not exists descricao_ar text;

-- ---- CONVIDADOS: cargo/organização + bio -----------------------------------
alter table public.speakers add column if not exists organizacao_en text;
alter table public.speakers add column if not exists organizacao_fr text;
alter table public.speakers add column if not exists organizacao_ar text;
alter table public.speakers add column if not exists bio_en text;
alter table public.speakers add column if not exists bio_fr text;
alter table public.speakers add column if not exists bio_ar text;

-- ============================================================================
-- NÃO se traduzem (ficam como estão): nomes de pessoas, siglas (GGPEN, MINTTICS),
-- locais (Stand GGPEN), país/origem. Só preenches as traduções que fizerem
-- sentido; o que deixares vazio cai automaticamente para o português.
--
-- Exemplo:
--   update public.activities
--     set titulo_en = 'OBSERVA+ Launch',
--         descricao_en = 'Official launch of the OBSERVA+ platform.'
--     where id = '<activity-uuid>';
-- ============================================================================
