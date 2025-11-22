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


