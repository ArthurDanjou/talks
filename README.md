# talks

Slides and source code for my academic talks, written in LaTeX (Beamer) or
[Slidev](https://sli.dev).

The complete list, with venues and dates, lives on my portfolio:
**[arthurdanjou.fr/publications](https://arthurdanjou.fr/publications)**.

Published slides are served from
[talks.arthurdanjou.fr](https://talks.arthurdanjou.fr). The root redirects to
the portfolio, and each talk has its own path.

## Talks in this repository

| Year | Talk | Format | Slides |
|---|---|---|---|
| 2026 | Krum, une bibliothèque pour l'agrégation robuste | Beamer | [PDF](https://talks.arthurdanjou.fr/2026/soutenance-m2-krum/slides.pdf) |

Talks without sources in this repository are listed on the portfolio.

## Structure

```
2026/
  soutenance-m2-krum/   Beamer sources, figures, and PDF
site/                   _redirects for the Pages site
scripts/
  build-slidev.sh       Build one Slidev deck with the right base path
deploy.sh               Build the site locally and deploy
.github/workflows/      Automatic deployment on push
```

## Build

### LaTeX

```sh
cd 2026/<talk>
latexmk -pdf slides.tex
```

The workflow compiles every `20*/*/slides.tex`. It installs a minimal TeX Live
set, so a talk that uses an additional package must add it to the `packages`
list in `.github/workflows/deploy.yml`.

### Slidev

```sh
./scripts/build-slidev.sh 2026/<talk>
```

The script installs the dependencies, then runs `slidev build` with the base
path derived from the directory. It requires a committed `bun.lock`.

## Deploy

A push to `master` touching `20*/**` or `site/**` triggers the GitHub Actions
workflow. It builds every talk, assembles `dist/`, and deploys to the Cloudflare
Pages project `talks`.

The workflow needs two repository secrets:

- `CLOUDFLARE_API_TOKEN`, with the Cloudflare Pages: Edit permission
- `CLOUDFLARE_ACCOUNT_ID`

To deploy locally:

```sh
./deploy.sh
```

## Adding a talk

Create `2026/<slug>/` with the sources for the format you use:

- LaTeX: `slides.tex`, `content/`, `assets/`, and `latexmkrc`. The PDF is
  published at `/2026/<slug>/slides.pdf`.
- Slidev: `slides.md`, `package.json`, and `bun.lock`. The deck is published at
  `/2026/<slug>/`.

Both formats can be added in the same commit, and one workflow run builds both.
A failure in one build blocks the deployment of the whole site.
