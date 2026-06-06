-- YouTube Content OS
-- Migration: 0001_initial_schema
-- Purpose: Initial Supabase schema for ideas, workflows, AI usage, scripts and metrics.

create extension if not exists pgcrypto;
create extension if not exists vector;

-- 1. Content ideas
create table if not exists public.content_ideas (
  id uuid primary key default gen_random_uuid(),
  topic text not null,
  source text,
  source_url text,
  angle text,
  audience text,
  trend_score numeric,
  audience_fit_score numeric,
  competition_score numeric,
  production_effort_score numeric,
  evergreen_score numeric,
  monetization_score numeric,
  final_priority_score numeric,
  status text not null default 'new',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 2. Workflow runs
create table if not exists public.workflow_runs (
  id uuid primary key default gen_random_uuid(),
  workflow_name text not null,
  workflow_version text,
  status text not null default 'started',
  input jsonb not null default '{}'::jsonb,
  output jsonb not null default '{}'::jsonb,
  error_message text,
  started_at timestamptz not null default now(),
  finished_at timestamptz
);

-- 3. AI usage logs
create table if not exists public.ai_usage_logs (
  id uuid primary key default gen_random_uuid(),
  workflow_run_id uuid references public.workflow_runs(id) on delete set null,
  provider text not null,
  model text,
  task_type text not null,
  input_tokens integer,
  output_tokens integer,
  cost_estimate numeric,
  latency_ms integer,
  status text not null default 'ok',
  error_message text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- 4. Research briefs
create table if not exists public.research_briefs (
  id uuid primary key default gen_random_uuid(),
  idea_id uuid references public.content_ideas(id) on delete cascade,
  title text,
  brief jsonb not null default '{}'::jsonb,
  sources jsonb not null default '[]'::jsonb,
  status text not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 5. Scripts
create table if not exists public.scripts (
  id uuid primary key default gen_random_uuid(),
  idea_id uuid references public.content_ideas(id) on delete cascade,
  research_brief_id uuid references public.research_briefs(id) on delete set null,
  title text,
  hook text,
  script_text text,
  scenes jsonb not null default '[]'::jsonb,
  status text not null default 'draft',
  version integer not null default 1,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 6. Assets
create table if not exists public.assets (
  id uuid primary key default gen_random_uuid(),
  script_id uuid references public.scripts(id) on delete set null,
  asset_type text not null,
  provider text,
  storage_url text,
  file_name text,
  mime_type text,
  duration_seconds numeric,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- 7. Videos
create table if not exists public.videos (
  id uuid primary key default gen_random_uuid(),
  script_id uuid references public.scripts(id) on delete set null,
  youtube_video_id text,
  title text,
  description text,
  tags text[],
  status text not null default 'draft',
  published_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 8. Daily YouTube metrics
create table if not exists public.video_metrics_daily (
  id uuid primary key default gen_random_uuid(),
  video_id uuid references public.videos(id) on delete cascade,
  metric_date date not null,
  views integer,
  impressions integer,
  ctr numeric,
  watch_time_minutes numeric,
  average_view_duration_seconds numeric,
  average_view_percentage numeric,
  likes integer,
  comments integer,
  shares integer,
  subscribers_gained integer,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  unique(video_id, metric_date)
);

-- 9. Knowledge base for future RAG
create table if not exists public.knowledge_base (
  id uuid primary key default gen_random_uuid(),
  source_type text not null,
  title text,
  content text not null,
  embedding vector(1536),
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- Indexes
create index if not exists idx_content_ideas_status on public.content_ideas(status);
create index if not exists idx_content_ideas_score on public.content_ideas(final_priority_score desc);
create index if not exists idx_workflow_runs_name on public.workflow_runs(workflow_name);
create index if not exists idx_ai_usage_provider_task on public.ai_usage_logs(provider, task_type);
create index if not exists idx_scripts_status on public.scripts(status);
create index if not exists idx_videos_status on public.videos(status);
create index if not exists idx_video_metrics_daily_date on public.video_metrics_daily(metric_date);

-- Updated at helper
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_content_ideas_updated_at on public.content_ideas;
create trigger trg_content_ideas_updated_at
before update on public.content_ideas
for each row execute function public.set_updated_at();

drop trigger if exists trg_research_briefs_updated_at on public.research_briefs;
create trigger trg_research_briefs_updated_at
before update on public.research_briefs
for each row execute function public.set_updated_at();

drop trigger if exists trg_scripts_updated_at on public.scripts;
create trigger trg_scripts_updated_at
before update on public.scripts
for each row execute function public.set_updated_at();

drop trigger if exists trg_videos_updated_at on public.videos;
create trigger trg_videos_updated_at
before update on public.videos
for each row execute function public.set_updated_at();

-- Security baseline
-- RLS enabled. We will not create public anon policies yet.
-- n8n will later use a secure backend/service credential, never a public browser key.

alter table public.content_ideas enable row level security;
alter table public.workflow_runs enable row level security;
alter table public.ai_usage_logs enable row level security;
alter table public.research_briefs enable row level security;
alter table public.scripts enable row level security;
alter table public.assets enable row level security;
alter table public.videos enable row level security;
alter table public.video_metrics_daily enable row level security;
alter table public.knowledge_base enable row level security;

grant usage on schema public to service_role;
grant all on all tables in schema public to service_role;
grant all on all sequences in schema public to service_role;
grant execute on all functions in schema public to service_role;
