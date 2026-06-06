# Step 04 — Secure Credentials

## Objective

Prepare secure credentials for Supabase, Gemini, OpenAI and Claude inside n8n.

No production workflows are created in this step.

## Credentials Required

### Supabase

Credential name:

YTOS_SUPABASE_SERVICE

Required values:

- SUPABASE_URL
- SUPABASE_SECRET_KEY or SERVICE_ROLE_KEY

Security note:

This key is server-side only and must never be exposed publicly.

### Gemini

Credential name:

YTOS_GEMINI_API

Required value:

- GEMINI_API_KEY

REST header planned:

x-goog-api-key: <GEMINI_API_KEY>

### OpenAI

Credential name:

YTOS_OPENAI_API

Required value:

- OPENAI_API_KEY

REST header planned:

Authorization: Bearer <OPENAI_API_KEY>

### Claude / Anthropic

Credential name:

YTOS_CLAUDE_API

Required value:

- ANTHROPIC_API_KEY

REST headers planned:

x-api-key: <ANTHROPIC_API_KEY>
anthropic-version: 2023-06-01
content-type: application/json

## Security Rules

- Do not commit secrets to GitHub.
- Do not paste API keys into documentation.
- Do not paste API keys into prompts.
- Do not expose service role keys in browsers.
- Do not leave paid AI webhooks unauthenticated.
- Rotate keys if they are accidentally exposed.

## n8n Credential Names

- YTOS_SUPABASE_SERVICE
- YTOS_GEMINI_API
- YTOS_OPENAI_API
- YTOS_CLAUDE_API

## Status

Pending manual creation in n8n.
