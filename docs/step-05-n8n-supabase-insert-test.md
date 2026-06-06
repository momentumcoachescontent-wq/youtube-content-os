# Step 05 — n8n to Supabase Insert Test

## Objective

Validate that n8n can insert records into Supabase.

## Workflow

Workflow name:

YTOS 01 - Supabase Insert Test

## Flow

Manual Trigger
→ Set Test Idea
→ Supabase Insert into content_ideas

## Supabase Table

public.content_ideas

## Test Record

source:

n8n_manual_test

status:

test

## Success Criteria

- n8n workflow executes successfully.
- A record is inserted into public.content_ideas.
- Supabase SQL query returns the inserted record.

## Status

Pending validation.
