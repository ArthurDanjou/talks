#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")/.."

if [ $# -ne 1 ]; then
  echo "usage: $0 <deck-dir>" >&2
  exit 1
fi

dir=${1%/}

if [ ! -f "$dir/slides.md" ]; then
  echo "no slides.md in $dir" >&2
  exit 1
fi

(
  cd "$dir"
  bun install --frozen-lockfile
  bunx slidev build --base "/$dir/" --out dist
)
