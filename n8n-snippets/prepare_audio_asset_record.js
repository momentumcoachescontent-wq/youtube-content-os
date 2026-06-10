// YTOS 05 - Prepare Audio Asset Record
// Nodo: Code | Language: JavaScript | Mode: Run Once for Each Item
// Robusto: sin IDs hardcodeados. Toma script_id/video_id de un nodo de contexto
// si existe; si no, de la entrada; falla con mensaje claro si faltan.

const drive = $input.first().json;

// 1) Contexto: intenta leer de nodos de contexto conocidos sin romper si no existen
function tryNode(name) {
  try { return $(name).first().json; } catch (e) { return null; }
}
const ctx =
  tryNode('Set Audio Generation Context') ||
  tryNode('Prepare Google Drive Audio Metadata') ||
  {};

const scriptId = ctx.script_id || drive.script_id || null;
const videoId = ctx.video_id || drive.video_id || null;
const projectRootFolderId = ctx.drive_root_folder_id || '1Ok5T46aZ6wMZuItSSGQcHPYJ5g0QwfCa';

if (!scriptId || !videoId) {
  throw new Error('Missing script_id/video_id. Add a Set node with these fields before Google Drive Upload Audio.');
}

const driveFileId = drive.id;
const driveFolderId =
  Array.isArray(drive.parents) && drive.parents.length > 0
    ? drive.parents[0]
    : projectRootFolderId;

if (!driveFileId) throw new Error('Google Drive upload did not return file id');

return {
  json: {
    script_id: scriptId,
    video_id: videoId,

    asset_type: ctx.asset_type || 'voiceover_audio',
    provider: ctx.provider || 'openai',
    repository: 'google_drive',

    file_name: drive.name,
    mime_type: drive.mimeType || 'audio/mp3',

    drive_file_id: driveFileId,
    drive_folder_id: driveFolderId,
    drive_web_view_link: drive.webViewLink || null,
    drive_web_content_link: drive.webContentLink || null,

    asset_status: 'created',
    version: 1,

    metadata: {
      storage_strategy: 'google_drive_project_root',
      project_root_folder_id: projectRootFolderId,
      actual_parent_folder_id: driveFolderId,
      folder_type: 'project_root',
      folder_path_logical: 'YTOS_GOOGLE_DRIVE/',

      model: ctx.model || null,
      voice: ctx.voice || null,

      file_size_bytes: drive.size ? Number(drive.size) : null,
      md5_checksum: drive.md5Checksum || null,
      sha256_checksum: drive.sha256Checksum || null,

      google_drive: {
        id: drive.id,
        name: drive.name,
        mimeType: drive.mimeType,
        webViewLink: drive.webViewLink,
        webContentLink: drive.webContentLink,
        parents: drive.parents || [],
        createdTime: drive.createdTime,
        size: drive.size || null
      }
    }
  }
};
