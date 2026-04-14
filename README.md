# AI-Generated Human Avatars: Emotion Fidelity Evaluation and Societal Impacts

Academic paper repository and accompanying dissemination artifacts for the research paper evaluating the emotional fidelity and societal impacts of Generative AI video avatars, targeting *AI & SOCIETY* (Springer Nature) Special Issue on Responsible Use of AI in Art Creation and Archival Practice.

## Structure

- `paper/` — LaTeX source for the academic manuscript (Springer Nature `sn-jnl` format) and submission cover letter.
- `website/` — Project dissemination website built with Zensical.

## Usage

Refer to `make help` at [Makefile](Makefile) to inspect all available workflow targets:

- `make deps` — Install subproject dependencies.
- `make build` — Compile paper, presentation slides, and static website.
- `make serve` — Preview the project website locally.
- `make test` — Verify build integrity across all subprojects.
- `make clean` — Clean generated build artifacts across subprojects.
- `make zip` — Generate a zip archive of the LaTeX paper source.
