# Step 12 — YTOS 06 Audio QA & Transcript Validation

## Workflow

YTOS 06 - Audio QA & Transcript

## Status

Closed functionally with QA needs_review.

## Purpose

Validate the generated audio asset, create a transcript asset, create an audio QA report asset, update workflow traceability, and set the script/video status according to the QA result.

## Final Result

YTOS 06 executed successfully from a technical perspective, but the audio QA result requires human review.

Final result:

audio_needs_review

QA status:

needs_review

## Main IDs

video_id:

3d828b05-9050-4000-8aae-766b3acf9408

script_id:

25bd87a5-5d6c-4310-8120-00c0ac2a1cdb

voiceover_audio_asset_id:

6fc88524-8e98-47dd-af54-b193a2e90728

transcript_asset_id:

4a360840-468d-485e-a8bc-9b6986b6dd6b

audio_qa_report_asset_id:

17b538ee-64a7-4f33-9b2f-63a0ac49dc51

workflow_run_id:

d3cf9fe2-81f2-4aaf-acb1-8910bbd21f7c

## Final Statuses

scripts.status:

audio_needs_review

videos.status:

audio_needs_review

workflow_runs.status:

completed

workflow_runs.output.result:

audio_needs_review

workflow_runs.output.qa_status:

needs_review

## Active Assets

The final active assets for this video are:

1. voiceover_audio
2. transcript_file
3. audio_quality_report

Previous duplicated transcript and QA assets generated during workflow testing were archived.

## Validation Notes

The final workflow run stores input and output as JSON objects.

The output correctly references:

- video_id
- script_id
- audio_asset_id
- transcript_asset_id
- audio_qa_report_asset_id
- result
- qa_status

## Known QA Issue

The audio QA report marked the result as needs_review.

This means the next stage should not be visual planning yet. The next required step is a human/audio remediation step to decide whether to approve the existing audio, regenerate audio, or adjust the script/TTS input.

## Next Recommended Workflow

YTOS 06A - Audio Review & Remediation

Expected decisions:

- approve_audio
- regenerate_audio
- revise_tts_text
- reject_audio

Only after approval should the status move to:

audio_approved

Then YTOS 07 can begin.

