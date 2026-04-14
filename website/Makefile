.PHONY: help deps build serve latex

help:
	@echo "deps        Install dependencies"
	@echo "build        Build website"
	@echo "serve        Run dev server"
	@echo "latex        Build LaTeX paper"

deps:
	pip install -r requirements.txt

build: docs/main.pdf
	zensical build

serve:
	zensical serve

latex: docs/main.pdf

docs/main.pdf: ../latex/main.tex
	cd ../latex && latexmk -pdf main
	cp ../latex/main.pdf docs/main.pdf