#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"

rm -rf dist
mkdir -p dist/2026/soutenance-m2-krum
cp site/index.html dist/index.html
cp 2026/soutenance-m2-krum/slides.pdf dist/2026/soutenance-m2-krum/slides.pdf

wrangler pages deploy dist --project-name=talks --branch=master
