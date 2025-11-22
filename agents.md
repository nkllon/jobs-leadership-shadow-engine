# Agents Playbook — Math Docs, Fast & Durable

The agent’s ass you save may be future you. Use this when publishing math-heavy docs quickly with reliable rendering and links.

## TL;DR paths (choose one)
- GitHub Pages (preferred, permanent): build HTML with MathJax → put in `docs/` → enable Pages → share `https://<user>.github.io/<repo>/`.
- Notebook + nbviewer (quick, good rendering): `.ipynb` in a public Gist → `https://nbviewer.org/gist/<user>/<gist-id>` (add `?flush_cache=true` after updates).
- Gist HTML + gistcdn.githack (pinned, permanent per revision): publish HTML as a Gist → use `https://gistcdn.githack.com/<user>/<gist-id>/raw/<rev>/file.html`.

## Rendering truths
- Prefer `$ ... $` and `$$ ... $$` delimiters. `\(...\)` and `\[...\]` may not render everywhere.
- Gists do not render LaTeX in Markdown. If you need math, use HTML (with MathJax) or a notebook.
- Uniform leading spaces turn Markdown into a code block. Remove them before blaming the renderer.

## MathJax v3 (drop-in config)
```html
<script>
window.MathJax = {
  tex: { inlineMath: [['$', '$'], ['\\(', '\\)']], displayMath: [['$$','$$'], ['\\[','\\]']] },
  svg: { fontCache: 'global' }
};
</script>
<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>
```

## One-command recipes
- Publish Markdown as a gist (note: no LaTeX rendering in-page):
```bash
gh gist create "/path/to/doc.md" --public -d "Title"
```
- Publish HTML (with MathJax) as a gist and get a permanent link for that revision:
```bash
gh gist create "/path/to/doc.html" --public -d "Title"
# Get raw URL, then convert to githack:
gh api gists/<GIST_ID> --jq '.files["doc.html"].raw_url'
# Use: https://gistcdn.githack.com/<user>/<GIST_ID>/raw/<REV>/doc.html
```
- Create repo from current folder and push:
```bash
gh repo create <user>/<repo> --public --source=. --remote=origin --push
```
- Enable GitHub Pages from `main:/docs`:
```bash
gh api -X POST repos/<user>/<repo>/pages -f "source[branch]=main" -f "source[path]=/docs" -f build_type=legacy \
  || gh api -X PUT repos/<user>/<repo>/pages -f "source[branch]=main" -f "source[path]=/docs"
```
- nbviewer link for a notebook gist:
```bash
# After: gh gist create file.ipynb --public ...
echo "https://nbviewer.org/gist/<user>/<gist-id>"
# If stale: append ?flush_cache=true
```

## Environment hygiene (save future you)
- Keep tokens shell-safe (quote values in `.env`); avoid sourcing secrets with unescaped `)`/`:` etc.
- `gh` uses `GH_TOKEN` or `GITHUB_TOKEN` with minimal scopes (gist, repo). Don’t spray unrelated env vars.

## Before you publish (checklist)
- [ ] Normalize math to `$`/`$$` delimiters.
- [ ] Remove leading indentation that forces code blocks.
- [ ] If using Pages: put HTML in `docs/`, add `.nojekyll`, optional `docs/index.html` redirect.
- [ ] Add README with links (Pages, nbviewer/gist).

## After you publish (checklist)
- [ ] GitHub Pages: wait a few minutes for first build; then verify.
- [ ] nbviewer: add `?flush_cache=true` if updates don’t show.
- [ ] Gist HTML: use `gistcdn.githack.com` (not `raw.githack.com`) and pin to a revision.

## Troubleshooting quick hits
- 404 on Pages: confirm source is `main:/docs` and file exists; wait for build.
- Raw TeX in gist: expected for `.md`. Switch to HTML+MathJax or notebook.
- Math not rendering in notebook viewer: switch to `$`/`$$`; ensure it’s a Markdown cell; flush cache.

## Nice-to-haves
- README badges/links to Pages/nbviewer.
- GitHub Action: Pandoc build from Markdown → `docs/` on push.
- Minimal `.gitignore` (`*.bak`, `.env`, `.DS_Store`), LICENSE.

## URL patterns to remember
- Pages: `https://<user>.github.io/<repo>/`
- nbviewer gist: `https://nbviewer.org/gist/<user>/<gist-id>`
- Gist HTML (pinned): `https://gistcdn.githack.com/<user>/<gist-id>/raw/<rev>/<file>`

## Example (this repo)
- Repo: https://github.com/nkllon/jobs-leadership-shadow-engine
- Pages: https://nkllon.github.io/jobs-leadership-shadow-engine/

## Repo runbook (this project)

### Code references (quick links)
- `.github/workflows/build-docs.yml`
- `scripts/build_docs.sh`
- `docs/index.html`
- `docs/jobs_shadow_math.html`
- `docs/coupling.html`
- `docs/.nojekyll`
- `jobs_shadow_math.md`
- `jobs_shadow_coupling_spec.json`
- `jobs_leadership_engine.ttl`
- `jobs_shadow_engine.ttl`
- `validation/shapes.ttl`
- `validation/validate.sh`

### Source-of-truth
- Math/prose: `jobs_shadow_math.md` (Markdown). The `.ipynb` is secondary (optional authoring), not used by CI.
- Ontologies: `.ttl` files are authoritative (OWL/RDF/Turtle).

### Local build (Markdown → HTML with MathJax)
```bash
./scripts/build_docs.sh
# Outputs: docs/jobs_shadow_math.html
# Ensures: docs/.nojekyll
# Copies:  jobs_shadow_coupling_spec.json → docs/
```

### CI build (on push to main)
- Workflow: `.github/workflows/build-docs.yml`
  - Installs `pandoc`, runs `scripts/build_docs.sh`, auto-commits `docs/` updates.
  - Publishing target is GitHub Pages (`main:/docs`).

### Visualization
- Data: `jobs_shadow_coupling_spec.json` (nodes/links; shadow ↔ 22D couplings).
- Viewer: `docs/coupling.html` (3D force-graph). On Pages: `/coupling.html`.
- Local preview: open `docs/coupling.html` directly or serve `docs/` statically.

### TTL validation (scaffold)
```bash
./validation/validate.sh
# Uses Apache Jena 'shacl' if available; otherwise prints guidance for pyshacl.
```

### Updated checklists
- Before you publish:
  - [ ] Normalize math to `$`/`$$`.
  - [ ] Run `./scripts/build_docs.sh` (verify MathJax rendering locally).
  - [ ] Ensure `docs/.nojekyll` exists.
  - [ ] (Optional) Run `./validation/validate.sh` on TTLs.
  - [ ] Confirm `docs/coupling.html` loads the JSON spec without console errors.
- After you publish:
  - [ ] Verify Pages serves `jobs_shadow_math.html` and `coupling.html`.
  - [ ] If updates don’t show, wait for CI or re-run workflow manually.

### Troubleshooting (repo-specific)
- `pandoc: command not found` → install pandoc (>= 2.17) and rerun.
- Jena `shacl` not found → install Apache Jena or use `pyshacl` as noted in `validation/validate.sh`.
- Viz JSON not loading → confirm `docs/jobs_shadow_coupling_spec.json` exists and path is correct.

### Hygiene
- Public HTML lives only under `docs/` (avoid duplicates at repo root).
- `.gitignore` includes common noise (`*.bak`, `.DS_Store`, `.ipynb_checkpoints/`).
- LICENSE: MIT.

### Cursor agent rules (this repo)
- Read `agents.md` and `README.md` before edits; summarize intent in your first status update.
- Use absolute paths in tool calls; prefer semantic code search to explore, regex search for exact matches.
- When citing existing code, use CODE REFERENCES blocks with start:end:filepath (no language tag).
- For new/proposed code, use Markdown code fences with a language tag.
- Maintain and update a TODO list for multi-step changes; set items in_progress/completed as you go.
- Only place public HTML under `docs/`; do not add HTML to repo root.
- For math publishing: normalize `$`/`$$` delimiters, then run `scripts/build_docs.sh`.
- After edits that affect `docs/`, re-run the build and verify `docs/jobs_shadow_math.html` renders and `docs/coupling.html` loads JSON.

### Maintainers & LLMs: operational checklist
- Local:
  - Build docs: `./scripts/build_docs.sh`
  - Preview: open `docs/jobs_shadow_math.html` and `docs/coupling.html`
  - Validate TTLs: `./validation/validate.sh`
- CI:
  - Confirm workflow ran on push to `main` (`.github/workflows/build-docs.yml`)
  - If needed, dispatch manually; verify Pages updated
- Hygiene:
  - Keep README links current; keep `.gitignore` up to date
  - Preserve MIT license header in new files

### Future improvements (suggested)
- Add link-check Action for `docs/` to prevent broken links.
- Run SHACL validation in CI (Jena `shacl` or `pyshacl`) and fail on violations.
- Pin Pandoc via a specific versioned action or container for reproducible builds.
- Add `CONTRIBUTING.md` and `CODEOWNERS` to guide external changes and reviews.


