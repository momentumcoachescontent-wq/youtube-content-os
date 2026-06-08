-- YouTube Content OS
-- Migration: 0003_google_drive_asset_repository
-- Purpose: Add Google Drive repository metadata to assets.

alter table public.assets
add column if not exists video_id uuid references public.videos(id) on delete set null;

alter table public.assets
add column if not exists repository text default 'google_drive';

alter table public.assets
add column if not exists drive_file_id text;

alter table public.assets
add column if not exists drive_folder_id text;

alter table public.assets
add column if not exists drive_web_view_link text;

alter table public.assets
add column if not exists drive_web_content_link text;

alter table public.assets
add column if not exists asset_status text default 'created';

alter table public.assets
add column if not exists version integer default 1;

create index if not exists idx_assets_video_id
on public.assets(video_id);

create index if not exists idx_assets_drive_file_id
on public.assets(drive_file_id);

create index if not exists idx_assets_repository
on public.assets(repository);

create index if not exists idx_assets_asset_status
on public.assets(asset_status);
