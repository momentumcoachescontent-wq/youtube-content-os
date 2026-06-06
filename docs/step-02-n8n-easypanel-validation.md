# Step 02 — n8n EasyPanel Validation

## Objective

Document the current n8n environment before building the YouTube Content OS workflows.

## Current n8n Environment

n8n is already deployed and available through EasyPanel.

n8n URL:

https://n8n-n8n.z3tydl.easypanel.host/home/workflows

## Deployment Decision

We will treat n8n as an EasyPanel-managed service, not as a manually managed VPS installation.

This means we will not start with SSH, Docker Compose inspection, or manual container changes.

## Operating Model

n8n will be used as the main workflow orchestrator.

Initial workflows will be created and tested from the n8n UI.

Workflows may expose remote webhook URLs when activated, but production webhooks must not be left unauthenticated.

## Webhook Security Rules

- Do not expose production webhooks with Authentication = None.
- Use Header Auth or JWT Auth for external triggers.
- Do not place API keys directly inside workflow nodes unless they are stored as n8n credentials.
- Do not expose workflows that can trigger paid AI calls without authentication.
- Public webhook URLs must be treated as API endpoints.
- Production workflows must log executions and errors.

## Initial Validation Checklist

- [ ] n8n UI is accessible.
- [ ] Login works.
- [ ] A test workflow can be created.
- [ ] A Manual Trigger workflow can execute.
- [ ] A Webhook Trigger workflow can expose a test URL.
- [ ] A Webhook Trigger workflow can expose a production URL when active.
- [ ] Webhook authentication options are available.
- [ ] n8n credentials can be created.
- [ ] Workflow export/import is available.
- [ ] Execution history is visible.

## Decision

Proceed with n8n UI-first construction.

No VPS-level changes required at this stage.
