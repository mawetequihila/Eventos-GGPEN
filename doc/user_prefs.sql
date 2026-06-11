...-- ============================================================================
-- Preferências do utilizador na conta (favoritos, lembretes, idioma...)
-- Necessário para a versão WEB: os dados deixam de ficar só no browser e passam
-- a seguir a conta (Google) em qualquer dispositivo. Correr no SQL Editor.
-- ============================================================================

create table if not exists public.user_prefs (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,  -- {favorites, reminders, leadMinutes, locale}
  updated_at timestamptz not null default now()
);

alter table public.user_prefs enable row level security;

-- Cada utilizador só lê/escreve a SUA própria linha.
drop policy if exists "own prefs" on public.user_prefs;
create policy "own prefs" on public.user_prefs
  for all
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
