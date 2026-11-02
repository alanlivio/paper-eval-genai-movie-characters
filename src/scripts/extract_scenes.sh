#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="${1:-data/inputs}"
mkdir -p "$OUT_DIR"

declare -A URLS=(
  ["anger"]="https://www.youtube.com/watch?v=2sLcfQKU_co"
  ["encouragement"]="https://www.youtube.com/watch?v=D_Vg4uyYwEk"
  ["joy"]="https://www.youtube.com/watch?v=Wey8nauEyA4"
  ["gratitude"]="https://www.youtube.com/watch?v=8SxE_NfUX6w"
)

declare -A START_TIMES=(
  ["anger"]="00:01:05"
  ["encouragement"]="00:01:12"
  ["joy"]="00:00:45"
  ["gratitude"]="00:01:50"
)

declare -A DURATIONS=(
  ["anger"]="00:00:05"
  ["encouragement"]="00:00:05"
  ["joy"]="00:00:05"
  ["gratitude"]="00:00:05"
)

for scene in "${!URLS[@]}"; do
  scene_dir="$OUT_DIR/$scene"
  mkdir -p "$scene_dir"
  yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4" -o "$scene_dir/raw.mp4" "${URLS[$scene]}"
  ffmpeg -loglevel error -y -ss "${START_TIMES[$scene]}" -t "${DURATIONS[$scene]}" -i "$scene_dir/raw.mp4" -c:v libx264 -c:a aac "$scene_dir/${scene}_trimmed.mp4"
  ffmpeg -loglevel error -y -i "$scene_dir/${scene}_trimmed.mp4" -vn -acodec libmp3lame -q:a 2 "$scene_dir/${scene}_audio.mp3"
  ffmpeg -loglevel error -y -i "$scene_dir/${scene}_trimmed.mp4" -vf "select=eq(n\,0)" -frames:v 1 -update 1 "$scene_dir/ref_${scene}.png"
done
