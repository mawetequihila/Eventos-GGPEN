-- ============================================================================
-- GGPEN APP — Alterações de schema no Supabase
-- Correr no SQL Editor do Supabase. Tudo é idempotente (pode correr 2x).
-- A app NÃO altera o schema; estas mudanças são aplicadas aqui manualmente.
-- ============================================================================

-- 1) ORADORES / CONVIDADOS -----------------------------------------------------
-- País e região (origem) da pessoa, mostrados na ficha do convidado.
alter table public.speakers add column if not exists pais   text;
alter table public.speakers add column if not exists origem text;  -- região / origem

-- Ordem de apresentação na página "Convidados" (menor = primeiro).
alter table public.speakers add column if not exists ordem  integer;

-- 1b) VISIBILIDADE DAS ATIVIDADES ---------------------------------------------
-- na_app = true  -> aparece na app dos participantes (aba Atividades).
-- na_app = false -> só na Agenda GGPEN (painel); NÃO aparece na app.
-- A app filtra por na_app=true (getActivities/getSpeakerSessions), por isso a
-- coluna é obrigatória. Default TRUE = atividades existentes continuam visíveis.
alter table public.activities add column if not exists na_app boolean not null default true;

-- (Opcional) flag separada da Agenda interna GGPEN; independente de na_app.
alter table public.activities add column if not exists interna boolean not null default false;

-- 2) LIGAÇÃO ATIVIDADE <-> CONVIDADO ------------------------------------------
-- Ordem dos intervenientes dentro de cada atividade (menor = primeiro).
alter table public.activity_speakers add column if not exists ordem integer;

-- Papel do interveniente na atividade. A app agrupa a aba "Intervenientes" por:
--   'moderador' -> secção Moderadores
--   'orador'    -> secção Oradores
--   qualquer outro valor (ex.: 'convidado') -> secção Convidados
-- Garante que a coluna existe e tem um valor por defeito sensato.
alter table public.activity_speakers
  add column if not exists papel text not null default 'orador';

-- Se existir um CHECK que limita os valores de 'papel', é preciso permitir
-- 'convidado'. Descomenta e ajusta o nome do constraint se for o teu caso:
--
-- alter table public.activity_speakers drop constraint if exists activity_speakers_papel_check;
-- alter table public.activity_speakers
--   add constraint activity_speakers_papel_check
--   check (papel in ('moderador','orador','convidado'));

-- 3) TEMPO REAL (OBRIGATÓRIO para o aviso de "horário alterado") --------------
-- A app escuta mudanças na tabela 'activities' para reagendar lembretes e
-- avisar o utilizador quando o organizador altera o horário de uma sessão.
-- Sem isto, a app só vê a hora nova ao reabrir/pull-to-refresh (não há aviso
-- automático enquanto está aberta).
alter publication supabase_realtime add table public.activities;
-- (Se já estiver na publicação, o comando dá erro inofensivo "already member".)

-- 4) ÍNDICES (opcional, ajudam a ordenação/leitura) ---------------------------
create index if not exists idx_speakers_ordem
  on public.speakers (ordem);
create index if not exists idx_activity_speakers_ordem
  on public.activity_speakers (activity_id, ordem);

-- ============================================================================
-- Exemplos de preenchimento (ajusta os ids/valores aos teus dados):
--
--   update public.speakers
--     set pais = 'Angola', origem = 'Luanda', ordem = 1
--     where id = '<speaker-uuid>';
--
--   update public.activity_speakers
--     set papel = 'convidado', ordem = 3
--     where activity_id = '<activity-uuid>' and speaker_id = '<speaker-uuid>';
-- ============================================================================
