#!/usr/bin/env bash
set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: $0 <slug>" >&2
  echo "Example: $0 my-new-post" >&2
  exit 1
fi

SLUG="$1"
hugo new "blog/${SLUG}.md"
hugo new "blog/${SLUG}.en.md" --kind blog-en

echo
echo "Created:"
echo "  content/blog/${SLUG}.md       (pt-BR, draft)"
echo "  content/blog/${SLUG}.en.md    (English, draft — fill in the 'slug:' field)"
