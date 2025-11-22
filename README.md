## Jobs Leadership Shadow Engine

A compact analytic “spore” that models a 22-dimensional leadership engine, its 4 shadow modulators, ethical dampers, and their couplings. This repo ships:
- machine-readable ontologies (OWL/RDF/Turtle),
- a math note with Attractor/Bifurcation framing,
- and a coupling visualization spec.

### Live docs
- GitHub Pages: https://nkllon.github.io/jobs-leadership-shadow-engine/
  - Redirects to `docs/jobs_shadow_math.html` (MathJax).
- Coupling viz (added in this plan): `docs/coupling.html` (loads `jobs_shadow_coupling_spec.json`).
  - Direct link: https://nkllon.github.io/jobs-leadership-shadow-engine/coupling.html

### Artifact map
- Ontologies:
  - `jobs_leadership_engine.ttl` — 22D engine (21 core + 1 meta).
  - `jobs_shadow_engine.ttl` — shadow modulators, ethical dampers, couplings.
- Math note (source-of-truth for prose/math):
  - `jobs_shadow_math.md` — Markdown with LaTeX math.
  - HTML build target: `docs/jobs_shadow_math.html` (MathJax v3).
  - Optional authoring: `jobs_shadow_math.ipynb` (secondary; not used by CI).
- Coupling visualization:
  - Spec: `jobs_shadow_coupling_spec.json` (nodes/links).
  - Viz page: `docs/coupling.html` (reads spec and renders 3D force graph).
- Publishing helpers:
  - `docs/index.html` — redirect to the math HTML.
  - `docs/.nojekyll` — served as static assets on Pages.
  - `agents.md`, `LESSONS_LEARNED.md` — publishing playbook and notes.

### Source-of-truth
- The math/prose source is `jobs_shadow_math.md`. The Notebook (`.ipynb`) is optional and not part of the automated build path.
- Ontologies are authored in Turtle (`.ttl`).

### Build the docs locally
Requirements:
- bash, `pandoc` (>= 2.17 recommended)

Steps:
```bash
./scripts/build_docs.sh
# Outputs: docs/jobs_shadow_math.html
# Copies:  docs/.nojekyll, docs/jobs_shadow_coupling_spec.json
```

### CI (GitHub Actions)
On push to `main`:
- Convert `jobs_shadow_math.md` → `docs/jobs_shadow_math.html` (MathJax v3).
- Copy `jobs_shadow_coupling_spec.json` → `docs/` for the viz page.
- Auto-commit the updated `docs/` to `main`.

### Validation (optional scaffolding)
See `validation/` for a stub SHACL/validation setup. You can wire in Apache Jena (riot/shacl) or RDFLib to lint/validate TTLs.

### License
MIT (see `LICENSE`).

### Links
- Repo: https://github.com/nkllon/jobs-leadership-shadow-engine
- Pages: https://nkllon.github.io/jobs-leadership-shadow-engine/


