#!/bin/sh
# Apply the DT295 patches to a clean upstream denpa tree.
# Usage: ./scripts/apply.sh /path/to/output
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
OUT=${1:-}
if [ -z "$OUT" ]; then
  echo "usage: $0 /path/to/output" >&2
  exit 2
fi
VERSION=$(cat "$ROOT/upstream.version")
UPSTREAM_URL=${UPSTREAM_URL:-https://github.com/danything/denpa.git}

mkdir -p "$OUT"
echo "fetching upstream denpa $VERSION ..."
if [ -d "$OUT/.git" ]; then
  git -C "$OUT" fetch --depth 1 origin "v$VERSION" 2>/dev/null || \
    git -C "$OUT" fetch --depth 1 origin "refs/tags/v$VERSION:refs/tags/v$VERSION"
  git -C "$OUT" checkout -f "v$VERSION"
else
  rm -rf "$OUT"
  git clone --depth 1 --branch "v$VERSION" "$UPSTREAM_URL" "$OUT"
fi

echo "applying patches ..."
cd "$OUT"
for p in "$ROOT"/patches/*.patch; do
  echo "  $(basename "$p")"
  git apply "$p"
done

echo "done. patched tree at $OUT"
echo "build with: docker build -t denpa-fork:prod $OUT"
