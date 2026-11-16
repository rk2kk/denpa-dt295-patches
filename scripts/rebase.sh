#!/bin/sh
# Update the tracked upstream version. Regenerate patches if needed.
# Usage: ./scripts/rebase.sh 2.52.0
set -eu

ROOT=$(cd "$(dirname "$0")/.." && pwd)
VERSION=${1:-}
if [ -z "$VERSION" ]; then
  echo "usage: $0 <upstream-version>" >&2
  exit 2
fi

echo "$VERSION" > "$ROOT/upstream.version"
echo "upstream.version -> $VERSION"
echo "Now run: ./scripts/apply.sh /path/to/output"
echo "If a patch conflicts, edit patches/*.patch by hand."
