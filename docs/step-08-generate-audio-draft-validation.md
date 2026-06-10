# Step 08 — Generate Audio Draft (YTOS 05) Validation

## Workflow

YTOS 05 - Generate Audio Draft

## Estado al 2026-06-10

El audio del MVP ya existía en Google Drive, pero el registro en `public.assets` nunca se insertó.

## Causa raíz encontrada

La migración `0003_google_drive_asset_repository.sql` existía en el repo pero **no estaba aplicada** en el proyecto Supabase (`slmnhfjukerypptqxjjb`). La tabla `assets` no tenía las columnas `video_id`, `repository`, `drive_file_id`, `drive_folder_id`, `drive_web_view_link`, `drive_web_content_link`, `asset_status`, `version`, por lo que el nodo "Insert Audio Asset Record" no podía mapear esos campos.

Adicionalmente, el nodo Code "Prepare Audio Asset Record" fallaba con `Referenced node doesn't exist` por referencias a nodos inexistentes (`Create Audio Folder`, `Prepare Google Drive Audio Metadata`).

## Correcciones aplicadas

1. Migración 0003 aplicada en Supabase vía MCP (`google_drive_asset_repository`).
2. Backfill del asset de audio del MVP en `public.assets`:
   - asset_id: 6fc88524-8e98-47dd-af54-b193a2e90728
   - drive_file_id: 1wLL7D7D8Tj_ZR-qGN-zN1IRxyPgcT1vm
   - script_id: 25bd87a5-5d6c-4310-8120-00c0ac2a1cdb
   - video_id: 3d828b05-9050-4000-8aae-766b3acf9408
3. `scripts.status` y `videos.status` actualizados de `approved_for_audio` → `audio_generated`.

## Pendientes en n8n (YTOS 05)

- Reemplazar el código de "Prepare Audio Asset Record" por la versión robusta en `n8n-snippets/prepare_audio_asset_record.js` (sin IDs hardcodeados).
- Verificar/crear el nodo "Insert Audio Asset Record" (Supabase → assets) con el mapeo documentado.
- Agregar nodos de actualización de estatus: scripts → `audio_generated`, videos → `audio_generated`.
- Exportar el JSON del workflow al repo (`n8n-workflows/`).

## Seguridad (pendiente manual)

- El archivo de audio en Drive tiene permiso `anyoneWithLink → writer`. Cambiar a `restricted` o máximo `viewer`.
- Hay audios duplicados de pruebas en la carpeta raíz de Drive; conservar solo `1wLL7D7D8Tj_ZR-qGN-zN1IRxyPgcT1vm`.

## Validación SQL

```sql
select id, script_id, video_id, asset_type, repository, file_name,
       drive_file_id, drive_folder_id, asset_status, created_at
from public.assets
where video_id = '3d828b05-9050-4000-8aae-766b3acf9408'
order by created_at desc;
```
