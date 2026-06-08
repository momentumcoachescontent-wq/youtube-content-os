-- YouTube Content OS
-- Migration: 0002_quality_reviews
-- Purpose: Add human review gate for scripts and video publishing packages.

create table if not exists public.quality_reviews (
  id uuid primary key default gen_random_uuid(),

  video_id uuid references public.videos(id) on delete cascade,
  script_id uuid references public.scripts(id) on delete set null,

  review_type text not null default 'publishing_package',
  status text not null default 'pending',

  reviewer_name text,
  score_overall numeric,
  score_title numeric,
  score_description numeric,
  score_thumbnail numeric,
  score_script numeric,
  score_factuality numeric,

  approved boolean default false,
  decision text,
  notes text,
  checklist jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_quality_reviews_video_id
on public.quality_reviews(video_id);

create index if not exists idx_quality_reviews_script_id
on public.quality_reviews(script_id);

create index if not exists idx_quality_reviews_status
on public.quality_reviews(status);

drop trigger if exists trg_quality_reviews_updated_at on public.quality_reviews;
create trigger trg_quality_reviews_updated_at
before update on public.quality_reviews
for each row execute function public.set_updated_at();

alter table public.quality_reviews enable row level security;

grant all on public.quality_reviews to service_role;
