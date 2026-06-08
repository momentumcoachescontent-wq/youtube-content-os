-- YouTube Content OS
-- Migration: 0004_drive_folders_catalog
-- Purpose: Catalog Google Drive folders per video.

create table if not exists public.drive_folders (
  id uuid primary key default gen_random_uuid(),

  video_id uuid references public.videos(id) on delete cascade,
  script_id uuid references public.scripts(id) on delete set null,

  folder_type text not null,
  folder_name text not null,
  logical_path text not null,

  drive_folder_id text not null,
  parent_drive_folder_id text,
  repository text not null default 'google_drive',

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  unique(video_id, folder_type)
);

create index if not exists idx_drive_folders_video_id
on public.drive_folders(video_id);

create index if not exists idx_drive_folders_script_id
on public.drive_folders(script_id);

create index if not exists idx_drive_folders_folder_type
on public.drive_folders(folder_type);

create index if not exists idx_drive_folders_drive_folder_id
on public.drive_folders(drive_folder_id);

drop trigger if exists trg_drive_folders_updated_at on public.drive_folders;
create trigger trg_drive_folders_updated_at
before update on public.drive_folders
for each row execute function public.set_updated_at();

alter table public.drive_folders enable row level security;

grant all on public.drive_folders to service_role;
