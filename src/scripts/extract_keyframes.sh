#!/usr/bin/env bash
set -euo pipefail

VIDEOS_DIR="${1:-../website/docs/videos}"
OUT_DIR="${2:-data/keyframes}"
mkdir -p "$OUT_DIR"

declare -A VIDEOS=(
  ["actor_anger"]="$VIDEOS_DIR/actor_anger.mp4"
  ["actor_encouragement"]="$VIDEOS_DIR/actor_encouragement.mp4"
  ["actor_joy"]="$VIDEOS_DIR/actor_joy.mp4"
  ["actor_grateful"]="$VIDEOS_DIR/actor_grateful.mp4"
  ["Runway_anger"]="$VIDEOS_DIR/Model_A_anger_cleaned.mp4"
  ["Runway_encouragement"]="$VIDEOS_DIR/Model_A_encouragement_updated.mp4"
  ["Runway_joy"]="$VIDEOS_DIR/Model_A_joy_cleaned.mp4"
  ["Runway_grateful"]="$VIDEOS_DIR/Model_A_grateful_cleaned.mp4"
  ["Hunyuan_anger"]="$VIDEOS_DIR/Model_B_anger_cleaned.mp4"
  ["Hunyuan_encouragement"]="$VIDEOS_DIR/Model_B_encoragement_updated.mp4"
  ["Hunyuan_joy"]="$VIDEOS_DIR/Model_B_joy_cleaned.mp4"
  ["Hunyuan_grateful"]="$VIDEOS_DIR/Model_B_grateful_cleaned.mp4"
)

for name in "${!VIDEOS[@]}"; do
  video_path="${VIDEOS[$name]}"
  if [ -f "$video_path" ]; then
    ffmpeg -loglevel error -y -ss 00:00:02 -i "$video_path" -frames:v 1 -update 1 "$OUT_DIR/${name}.png"
  fi
done
