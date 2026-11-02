# Emotion Fidelity Benchmark: Experimental Replication Suite

Source code, ComfyUI workflows, model configurations, and evaluation scripts to replicate the experiments in *"Emotion Fidelity Benchmark and Societal Impact of AI-Generated Human Videos"*.

## Repository Structure

- `configs/scenes.json` — Benchmark scene metadata, YouTube source URLs, text prompts, target FACS Action Units, and file mappings.
- `configs/hunyuan_avatar_settings.json` — Hyperparameters for Model B (HunyuanVideo-Avatar via Wan2GP / ComfyUI).
- `configs/i2v_settings.json` — Baseline Image-to-Video generation hyperparameters.
- `configs/prompts.txt` — Original text prompts used for each emotion category.
- `workflows/comfyui/runwayml_api_workflow.json` — ComfyUI API workflow for Model A (Runway Gen-3 Alpha / Gen-4 Image-to-Video node).
- `workflows/comfyui/model_A_image_to_video.json` — ComfyUI local Image-to-Video conditioning workflow.
- `workflows/comfyui/wan21_i2v_14b_480p.json` — ComfyUI workflow for Wan2.1 14B 480p GGUF baseline.
- `data/focus_group_ratings.csv` — Tabular dataset of expert ratings (`P1`, `P2`, mean scores, and qualitative notes) across all evaluated emotions.
- `scripts/extract_scenes.sh` — Automated pipeline to download source cinema clips via `yt-dlp`, trim 5-second benchmark segments, extract `.mp3` speech audio tracks, and save reference character frames.
- `scripts/extract_keyframes.sh` — Automated `ffmpeg` keyframe extraction from reference and generated videos to reproduce the comparison figures in the paper.
- `Makefile` — Standardized CLI entry point for running replication tasks.

## Hardware and Software Environment

All local open-source generation experiments were executed on standardized workstations with the following specifications:

- **CPU**: AMD Ryzen 9 5900X
- **RAM**: 64 GB DDR4
- **GPU**: NVIDIA GeForce RTX 4090 (24 GB VRAM)
- **Software Stack**:
  - [ComfyUI](https://github.com/comfyanonymous/ComfyUI) (Frontend `v1.21.0`)
  - [HunyuanVideo-Avatar](https://hunyuanvideo-avatar.com/) / [Wan2GP](https://github.com/deepbeepmeep/Wan2GP)
  - `ffmpeg` and `yt-dlp` for audio-visual preprocessing and keyframe extraction
  - Python 3.10+

## Step-by-Step Replication Guide

### Step 1: Prepare Benchmark Inputs (Audio & Reference Images)

The benchmark evaluates four canonical cinema scenes spanning distinct emotional and acoustic profiles:

1. **Anger** (*A Few Good Men*, 1992 — Jack Nicholson): `https://www.youtube.com/watch?v=2sLcfQKU_co`
2. **Encouragement** (*Rocky Balboa*, 2006 — Sylvester Stallone): `https://www.youtube.com/watch?v=D_Vg4uyYwEk`
3. **Joy** (*Dead Poets Society*, 1989 — Robin Williams): `https://www.youtube.com/watch?v=Wey8nauEyA4`
4. **Gratitude** (*Good Will Hunting*, 1997 — Robin Williams & Matt Damon): `https://www.youtube.com/watch?v=8SxE_NfUX6w`

To download the source clips, trim the 5-second benchmark segments, extract the speech audio tracks (`*_audio.mp3`), and export the reference character images (`ref_*.png`), run:

```bash
make extract-scenes
```

Pre-extracted reference images and actor benchmark videos are also archived directly in `../website/docs/images/` and `../website/docs/videos/actor_*.mp4`.

### Step 2: Replicate Model A (Runway Gen-3 Alpha)

Model A outputs were generated using Runway Gen-3 Alpha (Act-One audio/performance driving and Image-to-Video conditioning via ComfyUI API nodes):

1. Open ComfyUI and load `workflows/comfyui/runwayml_api_workflow.json`.
2. Configure your Runway API credentials in ComfyUI Settings.
3. In the `LoadImage` node, select the scene reference image (`ref_anger.png`, `ref_encouragement.png`, `ref_joy.png`, or `ref_grateful.png`).
4. In the Runway generation node, set the duration to `5` seconds, resolution to `1280:720`, and supply the corresponding scene prompt from `configs/scenes.json` (or drive via Runway Act-One using the trimmed actor clip `*_trimmed.mp4`).
5. Pre-generated outputs for Model A are stored in `../website/docs/videos/Model_A_*.mp4`.

### Step 3: Replicate Model B (HunyuanVideo-Avatar)

Model B outputs were generated using the open-source audio-driven Diffusion Transformer **HunyuanVideo-Avatar**:

1. Load the HunyuanVideo-Avatar checkpoint in Wan2GP or ComfyUI using the configuration in `configs/hunyuan_avatar_settings.json`:
   - **Resolution**: `832x480`
   - **Video Length**: `129` frames (~5 seconds)
   - **Inference Steps**: `30` (Flow Matching ODE solver, `flow_shift: 5`)
   - **Guidance Scale**: `7.5` (`embedded_guidance_scale: 6.0`)
2. Provide the scene reference image (`ref_*.png`), the extracted actor speech audio (`*_audio.mp3`), and the corresponding emotion prompt from `configs/scenes.json`:
   - **Anger**: *"A high-stakes courtroom showdown. The older officer erupts in fury—face red, veins bulging, fists clenched—shouting with righteous indignation. The tension is electric, the room frozen, as truth crashes down with explosive force."*
   - **Encouragement**: *"A weathered man stands firm under a gray sky, delivering an emotional, motivational speech. His body is tense but composed—shoulders squared, hands gesturing with restrained power. His face shows deep intensity—brows furrowed, eyes burning with resolve and compassion. He speaks with heartfelt conviction, urging strength and resilience despite life's hardships."*
   - **Joy**: *"A passionate teacher commands attention with piercing eye contact and assertive gestures. The room crackles with suppressed defiance and emotional intensity."*
   - **Gratitude**: *"A man speaks with tender, trembling voice. His body remains still as he is grounded by emotion. He is talking about how grateful he is with the moments he shared with his wife."*
3. Pre-generated outputs for Model B are stored in `../website/docs/videos/Model_B_*.mp4`.

### Step 4: Extract Comparison Keyframes and Inspect Ratings

To extract the comparison keyframes (`actor_*.png`, `Runway_*.png`, `Hunyuan_*.png`) used in Tables 3 and 4 of the manuscript:

```bash
make extract-keyframes
```

To inspect the focus group rating summary table (`P1`, `P2`, and mean scores across all scenes and models) from `data/focus_group_ratings.csv`:

```bash
make summary
```
