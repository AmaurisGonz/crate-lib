-- Lib Crate: Supabase setup
-- Run this once in your Supabase project: Dashboard → SQL Editor → New query → paste → Run.

-- 1. Table holding one row per book per user (title, type, reading progress).
create table if not exists public.books (
  user_id     uuid        not null default auth.uid() references auth.users (id) on delete cascade,
  id          text        not null,              -- SHA-256 hash of the file's contents
  name        text        not null,
  type        text        not null check (type in ('pdf', 'epub')),
  size        bigint      not null,
  progress    jsonb,                             -- {page,total,percent} for PDF, {cfi,percent} for EPUB
  progress_at timestamptz not null default now(),-- when progress last changed (newest wins)
  last_opened timestamptz not null default now(),
  added_at    timestamptz not null default now(),
  deleted_at  timestamptz,                       -- set when removed, so other devices remove it too
  primary key (user_id, id)
);

alter table public.books enable row level security;

create policy "Users manage their own books"
  on public.books for all to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- 2. Private storage bucket for the book files. Files live at <user id>/<hash>.<pdf|epub>.
insert into storage.buckets (id, name, public)
values ('books', 'books', false)
on conflict (id) do nothing;

create policy "Users read their own book files"
  on storage.objects for select to authenticated
  using (bucket_id = 'books' and (storage.foldername(name))[1] = (select auth.uid())::text);

create policy "Users upload their own book files"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'books' and (storage.foldername(name))[1] = (select auth.uid())::text);

create policy "Users update their own book files"
  on storage.objects for update to authenticated
  using (bucket_id = 'books' and (storage.foldername(name))[1] = (select auth.uid())::text)
  with check (bucket_id = 'books' and (storage.foldername(name))[1] = (select auth.uid())::text);

create policy "Users delete their own book files"
  on storage.objects for delete to authenticated
  using (bucket_id = 'books' and (storage.foldername(name))[1] = (select auth.uid())::text);
