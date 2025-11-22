#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

src_md="jobs_shadow_math.md"
out_dir="docs"
out_html="$out_dir/jobs_shadow_math.html"
spec_src="jobs_shadow_coupling_spec.json"
spec_dst="$out_dir/jobs_shadow_coupling_spec.json"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Error: pandoc not found. Install pandoc (>=2.17) and re-run." >&2
  exit 1
fi

mkdir -p "$out_dir"

# MathJax v3 configuration header
tmp_header="$(mktemp)"
cat >"$tmp_header" <<'EOF'
<script>
window.MathJax = {
  tex: { inlineMath: [['$', '$'], ['\\(', '\\)']], displayMath: [['$$','$$'], ['\\[','\\]']] },
  svg: { fontCache: 'global' }
};
</script>
EOF

title="Jobs Leadership Shadow Engine – Attractor & Bifurcation Math"
pandoc \
  --from=gfm \
  --to=html5 \
  --standalone \
  --metadata "title=$title" \
  --include-in-header "$tmp_header" \
  --mathjax="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml.js" \
  --output "$out_html" \
  "$src_md"

rm -f "$tmp_header"

# Ensure Pages serves raw files
touch "$out_dir/.nojekyll"

# Copy coupling spec for the viz page
if [[ -f "$spec_src" ]]; then
  cp "$spec_src" "$spec_dst"
fi

echo "Built: $out_html"
[[ -f "$spec_dst" ]] && echo "Copied: $spec_dst"
echo "Done."


