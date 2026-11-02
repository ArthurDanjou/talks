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

## Ajouter un talk Slidev

Créer un dossier `2026/mon-talk/` avec `slides.md`, `package.json` et
`bun.lock`. Le workflow construit le deck avec `--base /2026/mon-talk/` et le
publie à cette adresse.

Pour tester localement :

```sh
cd 2026/mon-talk
bun install
bunx slidev build --base /2026/mon-talk/ --out dist
```
