# talks

Slides &amp; code for my academic talks, in [Slidev](https://sli.dev) or LaTeX.

[Upcoming Talks](https://arthurdanjou.fr/talks)

###### 2026

- `fr` **Krum, une bibliothèque pour l'agrégation robuste** — _Soutenance M2 ISF, CMAP, École polytechnique_ · [PDF](https://talks.arthurdanjou.fr/2026/soutenance-m2-krum/slides.pdf)
- `fr` **Robustesse Byzantine dans l'Apprentissage Distribué** — _Séminaire interne CMAP, Ecole Polytechnique_

## Deploy

```sh
./deploy.sh
```

Le script assemble `dist/` à partir de `site/_redirects`, des PDF et des builds
Slidev, puis publie sur le projet Cloudflare Pages `talks`.

Le même déploiement est automatisé par GitHub Actions à chaque push sur
`master`. Le workflow `.github/workflows/deploy.yml` demande deux secrets :
`CLOUDFLARE_API_TOKEN`, avec le droit Cloudflare Pages: Edit, et
`CLOUDFLARE_ACCOUNT_ID`.

## Ajouter un talk LaTeX

Placer `slides.tex` dans `2026/mon-talk/`, avec ses fichiers `content/`,
`assets/` et `latexmkrc`. Le workflow compile chaque `20*/*/slides.tex` et
publie le PDF à `/2026/mon-talk/slides.pdf`.

Le workflow installe un ensemble minimal de paquets TeX Live. Si le talk
utilise un paquet supplémentaire, l'ajouter à la liste `packages` de
`.github/workflows/deploy.yml`.

## Ajouter un talk Slidev

Créer un dossier `2026/mon-talk/` avec `slides.md`, `package.json` et
`bun.lock`. Tu peux en avoir plusieurs : chaque dossier `20*/*/` qui contient
un `slides.md` est construit avec `--base /20xx/mon-talk/` et publié à cette
adresse.

Pour construire un deck :

```sh
./scripts/build-slidev.sh 2026/mon-talk
```

Le script installe les dépendances et calcule automatiquement `--base` et
`--out` à partir du chemin du dossier.
