# Step 06 — Research to Script MVP

## Objective

Build the first useful n8n workflow for YouTube Content OS.

This step skips isolated connection tests and moves directly into a real MVP workflow.

## Workflow Name

YTOS 02 - Research to Script MVP

## Flow

Manual Trigger
→ Set Topic
→ Gemini Research
→ OpenAI Content Score JSON
→ Claude Script Writer
→ Supabase Insert / Update

## Prompt Files

- prompts/gemini_research.md
- prompts/openai_content_score_json.md
- prompts/claude_script_writer.md

## Supabase Tables Used

- content_ideas
- research_briefs
- scripts
- workflow_runs
- ai_usage_logs

## Success Criteria

- A manual topic can be entered.
- Gemini produces a research brief.
- OpenAI converts the brief into structured JSON.
- Claude generates a draft script.
- Supabase stores the idea, research brief and script.
- No API keys are exposed in workflow notes or repository files.

## Status

Pending workflow construction in n8n.
