-- ═══════════════════════════════════════════════════════════
--  NEXUS GATEWAY — Schema SQL per Supabase
--  Esegui questo script nell'SQL Editor di Supabase
--  (Dashboard → SQL Editor → New query → incolla → Run)
-- ═══════════════════════════════════════════════════════════

-- Tabella profili utente (collegata a auth.users)
create table if not exists public.profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  username      text unique not null,
  login_count   integer not null default 0,
  last_login    timestamptz,
  created_at    timestamptz not null default now()
);

-- Indice per ricerca veloce per username
create index if not exists profiles_username_idx on public.profiles(username);

-- ─── ROW LEVEL SECURITY ───────────────────────────────────
-- Ogni utente può leggere e modificare SOLO il proprio profilo

alter table public.profiles enable row level security;

-- Chiunque può leggere profili (per check username duplicati)
create policy "Lettura profili pubblica"
  on public.profiles for select
  using (true);

-- Ogni utente può aggiornare solo sé stesso
create policy "Aggiornamento solo proprio profilo"
  on public.profiles for update
  using (auth.uid() = id);

-- ─── TRIGGER: crea profilo automaticamente al signup ──────
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', split_part(new.email, '@', 1))
  );
  return new;
end;
$$;

-- Collega il trigger alla tabella auth.users
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ─── VERIFICA (opzionale) ─────────────────────────────────
-- Dopo aver eseguito, puoi verificare con:
-- select * from public.profiles;