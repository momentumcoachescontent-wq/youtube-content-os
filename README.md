# YouTube Content OS

Sistema para orquestar la creación automatizada de contenido para YouTube usando n8n, Supabase, Cloudflare, Gemini, OpenAI y Claude.

## Estado del proyecto

Etapa actual: MVP del pipeline en n8n (YTOS 01–05).

| Workflow | Estado |
|---|---|
| YTOS 01 - Supabase Insert Test | Validado |
| YTOS 02 - Research to Script MVP | Validado (run completed) |
| YTOS 03 - Script to Publishing Package | Construido |
| YTOS 04 - Human Review Decision | Validado (approved_for_audio) |
| YTOS 05 - Generate Audio Draft | Audio en Drive; registro en assets y updates de status agregados (ver docs/step-08) |

## Estructura

- `docs/` — bitácora paso a paso del proyecto
- `supabase/migrations/` — esquema de la base (aplicar en orden)
- `prompts/` — prompts de Gemini, OpenAI y Claude usados en los workflows
- `n8n-workflows/` — exports JSON de los workflows
- `n8n-snippets/` — código de nodos Code para copiar/pegar

## Pendientes de seguridad

- Cambiar permisos de Drive `anyoneWithLink: writer` → `viewer` o restricted
- No activar webhooks de producción sin Header/JWT auth
- Poblar `ai_usage_logs` desde los workflows (costos y latencia)
