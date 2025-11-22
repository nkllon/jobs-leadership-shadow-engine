# Lessons Learned — Jobs Leadership Shadow Engine Publishing

## Summary
We took a Markdown math doc to multiple public formats (gist, notebook, GitHub Pages) and made the math render reliably. Along the way we hit renderer differences, caching, and hosting nuances.

## Markdown and Math Rendering
- Prefer `$ ... $` and `$$ ... $$` delimiters for broad compatibility. `\(...\)` and `\[...\]` are fine but not universally enabled.
- Editor previews may treat leading spaces as code blocks. Avoid uniform leading indentation; fix before troubleshooting renderers.
- Gists do not render LaTeX in Markdown. They’re for code/snippets, not math typesetting.

## Rendering Paths (What Works Well)
- Colab/Jupyter: Markdown cells render LaTeX; notebooks are portable and easy to share.
- nbviewer: Renders `.ipynb` hosted on GitHub/Gist. Caching can mask updates; use `?flush_cache=true` when needed.
- Static HTML with MathJax: Most robust and portable. Include MathJax v3 from a CDN and configure both inline and display math.

### MathJax v3 config used
```html
<script>
window.MathJax = {
  tex: { inlineMath: [['$', '$'], ['\\(', '\\)']], displayMath: [['$$','$$'], ['\\[','\\]']] },
  svg: { fontCache: 'global' }
};
</script>
<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js"></script>
```

## Hosting and Links
- Gist + raw.githack: Use `gistcdn.githack.com` for gist content (not `raw.githack.com`). Pin to a specific revision for permanence.
- GitHub Pages: Simple and durable. Serve prebuilt HTML from `main:/docs` with `.nojekyll`. A minimal `docs/index.html` can redirect to your primary HTML.
- Pages propagation: Initial builds can take a few minutes. Be patient before declaring a failure.

## GitHub CLI and API Tips
- `gh gist create file --public -d "desc"` is reliable for first publish; edits are easier via `gh api` for binary/large files.
- For nbviewer: construct `https://nbviewer.org/gist/<user>/<gist-id>` and use `?flush_cache=true` after updates.
- For Pages: enable via API or repo settings. We used `main:/docs` as source and added `.nojekyll`.

## Secrets and Environment
- Sourcing `~/.env` in a shell can break if lines contain unquoted special characters (e.g., `)` or `:`). Prefer `export KEY='value'` formatting or avoid sourcing untrusted values.
- `gh` respects `GH_TOKEN` (or `GITHUB_TOKEN`). Set only what you need; avoid exporting unrelated secrets into the shell.

## Repo Hygiene
- Keep generated public assets in `docs/`. Avoid duplicates in repo root.
- Add a README with: project overview, Pages URL, and how to rebuild HTML.
- Add a LICENSE and a minimal `.gitignore` (e.g., `*.bak`, `.env`, `.DS_Store`).

## Automation Ideas
- Add a GitHub Action to convert `jobs_shadow_math.md` → `docs/jobs_shadow_math.html` on push (Pandoc + MathJax template), eliminating manual HTML edits.
- Optional link check step to catch broken links in docs.

## Practical Checklist (Next Time)
- [ ] Normalize math delimiters to `$`/`$$`.
- [ ] Confirm no leading indentation in Markdown.
- [ ] If using gists, assume no LaTeX rendering; use HTML or notebooks.
- [ ] Prefer Pages-hosted MathJax HTML for permanent public links.
- [ ] Pin CDN links (MathJax) and verify offline fallback if needed.
- [ ] Keep tokens minimal and `.env` shell-safe (quoted).

## Final URLs
- Repository: https://github.com/nkllon/jobs-leadership-shadow-engine
- GitHub Pages (docs): https://nkllon.github.io/jobs-leadership-shadow-engine/


