MAKEFLAGS += -s --no-print-directory
export PATH := $(HOME)/.local/bin:$(PATH)
.DEFAULT_GOAL := help

.PHONY: help deps build serve test clean zip

help:
	@printf "%s\n" \
		"Usage: make [target]" \
		"" \
		"Targets:" \
		"  deps     Install dependencies across subprojects" \
		"  serve    Serve the website locally" \
		"  test     Run verification tests and builds" \
		"  clean    Clean build artifacts across subprojects" \
		"  zip      Create paper submission archive"

deps:
	which latexmk >/dev/null 2>&1 || (echo "latexmk not found" && exit 1)
	npx --yes @marp-team/marp-cli --version >/dev/null 2>&1 || (echo "marp-cli not found" && exit 1)
	which zensical >/dev/null 2>&1 || (echo "zensical not found" && exit 1)

paper/main.pdf: paper/main.tex paper/references.bib
	latexmk -pdf -synctex=1 -interaction=nonstopmode -cd paper/main.tex

paper/letter.pdf: paper/letter.tex
	latexmk -pdf -synctex=1 -interaction=nonstopmode -cd paper/letter.tex


website/docs/main.pdf: paper/main.pdf
	mkdir -p website/docs
	cp paper/main.pdf website/docs/main.pdf
	(cd website && zensical serve)

test: build

clean:
	latexmk -C -cd paper/main.tex
	latexmk -C -cd paper/letter.tex
	rm -f paper/paper.tar.gz paper/*.docx

zip: paper/main.pdf paper/letter.pdf
	(cd paper && tar -czvf paper.tar.gz main.tex references.bib letter.tex sn-jnl.cls sn-basic.bst sn-mathphys-num.bst assets main.pdf letter.pdf)
