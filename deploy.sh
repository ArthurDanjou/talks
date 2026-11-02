#!/usr/bin/env sh
set -eu

cd "$(dirname "$0")"

for deck in 20*/*/slides.md; do
  [ -f "$deck" ] || continue
  ./scripts/build-slidev.sh "$(dirname "$deck")"
done

rm -rf dist
mkdir -p dist
cp site/_redirects dist/_redirects

for pdf in 20*/*/slides.pdf; do
  [ -f "$pdf" ] || continue
  mkdir -p "dist/$(dirname "$pdf")"
  cp "$pdf" "dist/$pdf"
done

for deck in 20*/*/slides.md; do
  [ -f "$deck" ] || continue
  dir=$(dirname "$deck")
  mkdir -p "dist/$dir"
  cp -R "$dir/dist/." "dist/$dir/"
done

wrangler pages deploy dist --project-name=talks --branch=master
