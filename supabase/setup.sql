-- =====================================================================
-- 质检工作台 · Supabase 初始化脚本
-- 用法：Supabase 后台 → SQL Editor → New query → 整段粘贴 → Run。
-- 可以重复运行，不会删除已有数据。
-- =====================================================================

-- 1. 成员表：每个登录账号一行，角色决定权限
--    admin 管理员 / qc 质检专员 / viewer 只读 / pending 待审核
create table if not exists public.members (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  email      text,
  name       text,
  role       text not null default 'pending'
             check (role in ('admin','qc','viewer','pending')),
  created_at timestamptz not null default now()
);

-- 2. 数据表：工作台的所有数据都以文档形式存在这里
--    col = 数据分类（qc 质检记录、tasks 任务、roster 教练名单……），id = 文档编号
create table if not exists public.docs (
  col        text not null,
  id         text not null,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid default auth.uid(),
  primary key (col, id)
);
alter table public.docs replica identity full;

-- 3. 当前登录人的角色
create or replace function public.my_role() returns text
language sql stable security definer set search_path = public as $$
  select role from public.members where user_id = auth.uid()
$$;

-- 4. 当前登录人能不能写某类数据
--    管理员写全部；质检专员不能改标准、教练名单、退费明细、导入记录和各项设置
create or replace function public.can_write(c text) returns boolean
language sql stable security definer set search_path = public as $$
  select case public.my_role()
    when 'admin' then true
    when 'qc'    then c not in ('roster','config','stdver','imports','refunds')
    else false
  end
$$;

-- 5. 新账号注册时自动加入成员表：第一个注册的账号是管理员，其余为待审核
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.members (user_id, email, name, role)
  values (
    new.id,
    new.email,
    coalesce(nullif(new.raw_user_meta_data->>'name', ''), split_part(new.email, '@', 1)),
    case when exists (select 1 from public.members) then 'pending' else 'admin' end
  )
  on conflict (user_id) do nothing;
  return new;
end $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 6. 行级权限：没登录、待审核的账号读不到任何业务数据
alter table public.members enable row level security;
alter table public.docs    enable row level security;

drop policy if exists members_select on public.members;
create policy members_select on public.members for select to authenticated
  using (user_id = auth.uid() or public.my_role() in ('admin','qc','viewer'));

drop policy if exists members_admin_update on public.members;
create policy members_admin_update on public.members for update to authenticated
  using (public.my_role() = 'admin') with check (public.my_role() = 'admin');

drop policy if exists docs_select on public.docs;
create policy docs_select on public.docs for select to authenticated
  using (public.my_role() in ('admin','qc','viewer'));

drop policy if exists docs_insert on public.docs;
create policy docs_insert on public.docs for insert to authenticated
  with check (public.can_write(col));

drop policy if exists docs_update on public.docs;
create policy docs_update on public.docs for update to authenticated
  using (public.can_write(col)) with check (public.can_write(col));

drop policy if exists docs_delete on public.docs;
create policy docs_delete on public.docs for delete to authenticated
  using (public.can_write(col));

-- 7. 开启实时同步（同事的修改会实时出现在别人的页面上）
do $$ begin
  alter publication supabase_realtime add table public.docs;
exception when duplicate_object then null;
end $$;

-- 完成。回到工作台网址，第一个注册的账号就是管理员。
