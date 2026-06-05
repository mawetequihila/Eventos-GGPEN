-- ============================================================================
-- FCM — Tabela de tokens de dispositivo
-- Cada telemóvel regista aqui o seu token FCM para o servidor poder enviar push.
-- Correr no SQL Editor do Supabase.
-- ============================================================================

create table if not exists public.device_tokens (
  token      text primary key,
  user_id    uuid references auth.users(id) on delete set null,
  platform   text,                          -- 'android' | 'iOS' | ...
  updated_at timestamptz not null default now()
);

alter table public.device_tokens enable row level security;

-- A app (anon ou autenticada) precisa de poder gravar/atualizar o próprio token.
-- O token não é informação sensível; a leitura em massa é feita só pelo servidor
-- (Edge Function) com a service_role key, que ignora RLS.
drop policy if exists "device tokens upsert" on public.device_tokens;
create policy "device tokens upsert" on public.device_tokens
  for all
  to anon, authenticated
  using (true)
  with check (true);

create index if not exists idx_device_tokens_user on public.device_tokens (user_id);
