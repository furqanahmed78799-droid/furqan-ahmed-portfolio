-- Furqan Ahmed portfolio CMS: run this in Supabase SQL Editor.
-- Before using the site, create your admin user in Supabase Authentication > Users.
-- Replace ADMIN_USER_UUID below with that user's UUID from Authentication > Users.
create extension if not exists pgcrypto;

create table if not exists public.portfolio_items (
  id uuid primary key default gen_random_uuid(),
  kind text not null check (kind in ('project','video','photo','certificate')),
  title text not null,
  category text,
  description text,
  external_url text,
  storage_path text,
  file_url text,
  file_type text,
  display_order integer not null default 0,
  is_public boolean not null default true,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.portfolio_items enable row level security;

drop policy if exists "Public can view published portfolio items" on public.portfolio_items;
create policy "Public can view published portfolio items"
on public.portfolio_items for select
using (is_public = true or auth.uid() = 'ADMIN_USER_UUID'::uuid);

drop policy if exists "Admin can insert portfolio items" on public.portfolio_items;
create policy "Admin can insert portfolio items"
on public.portfolio_items for insert
with check (auth.uid() = 'ADMIN_USER_UUID'::uuid);

drop policy if exists "Admin can update portfolio items" on public.portfolio_items;
create policy "Admin can update portfolio items"
on public.portfolio_items for update
using (auth.uid() = 'ADMIN_USER_UUID'::uuid)
with check (auth.uid() = 'ADMIN_USER_UUID'::uuid);

drop policy if exists "Admin can delete portfolio items" on public.portfolio_items;
create policy "Admin can delete portfolio items"
on public.portfolio_items for delete
using (auth.uid() = 'ADMIN_USER_UUID'::uuid);

-- Create a PUBLIC bucket for portfolio assets. Public means visitors can view files
-- when they know the URL; upload/delete permissions remain restricted by policies.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('portfolio-files', 'portfolio-files', true, 157286400,
        array['image/jpeg','image/png','image/webp','image/gif','video/mp4','video/webm','application/pdf'])
on conflict (id) do update set public = true, file_size_limit = 157286400;

drop policy if exists "Public can view portfolio assets" on storage.objects;
create policy "Public can view portfolio assets"
on storage.objects for select
using (bucket_id = 'portfolio-files');

drop policy if exists "Admin can upload portfolio assets" on storage.objects;
create policy "Admin can upload portfolio assets"
on storage.objects for insert
with check (bucket_id = 'portfolio-files' and auth.uid() = 'ADMIN_USER_UUID'::uuid and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Admin can update portfolio assets" on storage.objects;
create policy "Admin can update portfolio assets"
on storage.objects for update
using (bucket_id = 'portfolio-files' and auth.uid() = 'ADMIN_USER_UUID'::uuid and (storage.foldername(name))[1] = auth.uid()::text)
with check (bucket_id = 'portfolio-files' and auth.uid() = 'ADMIN_USER_UUID'::uuid and (storage.foldername(name))[1] = auth.uid()::text);

drop policy if exists "Admin can delete portfolio assets" on storage.objects;
create policy "Admin can delete portfolio assets"
on storage.objects for delete
using (bucket_id = 'portfolio-files' and auth.uid() = 'ADMIN_USER_UUID'::uuid and (storage.foldername(name))[1] = auth.uid()::text);
