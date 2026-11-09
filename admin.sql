-- Execute no SQL Editor, depois crie seu usuário em Authentication > Users.
create table if not exists public.market_admins (
 user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.market_admins enable row level security;
revoke all on public.market_admins from anon, authenticated;

create or replace function public.market_list_pending()
returns table (id uuid, nome text, contato text, categoria text, cidade text, titulo text, preco text, descricao text, status text, criado_em timestamptz)
language plpgsql security definer set search_path = '' as $$
begin
 if auth.uid() is null or not exists(select 1 from public.market_admins where user_id=auth.uid()) then
  raise exception 'Acesso não autorizado';
 end if;
 return query select a.id,a.nome,a.contato,a.categoria,a.cidade,a.titulo,a.preco,a.descricao,a.status,a.criado_em
 from public.anuncios a where a.status='pendente' order by a.criado_em asc limit 200;
end $$;

create or replace function public.market_moderate(ad_id uuid, new_status text)
returns boolean language plpgsql security definer set search_path = '' as $$
begin
 if auth.uid() is null or not exists(select 1 from public.market_admins where user_id=auth.uid()) then
  raise exception 'Acesso não autorizado';
 end if;
 if new_status not in ('aprovado','rejeitado') then raise exception 'Status inválido'; end if;
 update public.anuncios set status=new_status where id=ad_id and status='pendente';
 return found;
end $$;
revoke all on function public.market_list_pending() from public, anon;
revoke all on function public.market_moderate(uuid,text) from public, anon;
grant execute on function public.market_list_pending() to authenticated;
grant execute on function public.market_moderate(uuid,text) to authenticated;
-- IMPORTANTE: Depois de criar seu usuário no Supabase Authentication, execute separadamente:
-- insert into public.market_admins(user_id) values ('UUID-DO-SEU-USUARIO');
