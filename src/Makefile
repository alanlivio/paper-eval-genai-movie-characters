MAKEFLAGS += -s --no-print-directory
.DEFAULT_GOAL := help

.PHONY: help deps extract-scenes extract-keyframes summary clean

help:
	@printf "%s\n" \
		"Usage: make [target]" \
		"" \
		"Targets:" \
		"  help               Show this help message" \
		"  deps               Verify required CLI tools (ffmpeg, yt-dlp, python3)" \
		"  extract-scenes     Download and trim reference movie clips, audio, and reference frames" \
		"  extract-keyframes  Extract comparison keyframes from generated Model A and Model B videos" \
		"  summary            Print summary statistics from focus group evaluation CSV" \
		"  clean              Remove generated keyframes and temporary outputs"

deps:
	which ffmpeg >/dev/null 2>&1 || (echo "ffmpeg not found" && exit 1)
	which python3 >/dev/null 2>&1 || (echo "python3 not found" && exit 1)

extract-scenes:
	bash scripts/extract_scenes.sh data/inputs

extract-keyframes:
	bash scripts/extract_keyframes.sh ../website/docs/videos data/keyframes

summary:
	python3 -c "import csv; rows = list(csv.DictReader(open('data/focus_group_ratings.csv'))); print('Scene          | Model                     | P1 | P2 | Mean'); print('-'*60); [print(f\"{r['emotion']:14} | {r['model_name']:25} | {r['p1_rating']:2} | {r['p2_rating']:2} | {r['mean_rating']}\") for r in rows]"

clean:
	rm -rf data/inputs data/keyframes
