-- Execute no SQL Editor do Supabase. Confirme pagamentos em seu banco antes de aprovar.
create table if not exists public.anuncios (
 id uuid primary key default gen_random_uuid(),
 nome text not null check (char_length(nome) between 1 and 60),
 contato text not null check (char_length(contato) between 1 and 100),
 categoria text not null check (categoria in ('Carros','Armas virtuais','Serviços RP')),
 cidade text not null check (char_length(cidade) between 1 and 80),
 titulo text not null check (char_length(titulo) between 1 and 100),
 preco text not null check (char_length(preco) between 1 and 40),
 descricao text not null check (char_length(descricao) between 1 and 700),
 status text not null default 'pendente' check (status in ('pendente','aprovado','rejeitado')),
 criado_em timestamptz not null default now()
);
alter table public.anuncios enable row level security;
drop policy if exists "Leitura publica apenas aprovados" on public.anuncios;
create policy "Leitura publica apenas aprovados" on public.anuncios for select to anon, authenticated using (status='aprovado');
drop policy if exists "Criar apenas pendentes" on public.anuncios;
create policy "Criar apenas pendentes" on public.anuncios for insert to anon, authenticated with check (status='pendente');
-- Sem políticas de update/delete para usuários públicos. Moderação pelo painel seguro Supabase.
grant select, insert on public.anuncios to anon, authenticated;
-- ATENÇÃO: habilite CAPTCHA/limitação de requisições antes de uso em escala.
