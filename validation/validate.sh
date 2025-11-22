#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

ttl_files=( "jobs_leadership_engine.ttl" "jobs_shadow_engine.ttl" )
shapes="validation/shapes.ttl"

echo "Validating TTL files against shapes (if Apache Jena 'shacl' is installed)..."
if command -v shacl >/dev/null 2>&1; then
  for f in "${ttl_files[@]}"; do
    echo "→ $f"
    shacl validate --datafile "$f" --shapesfile "$shapes" || true
  done
  echo "Done."
else
  echo "Jena 'shacl' CLI not found. Install Apache Jena or use RDFLib SHACL."
  echo "Examples:"
  echo "  - Apache Jena: https://jena.apache.org/documentation/shacl/"
  echo "  - RDFLib pyshacl: pip install pyshacl && pyshacl -s $shapes -d jobs_leadership_engine.ttl"
fi


