# talks

Slides &amp; code for my academic talks, in [Slidev](https://sli.dev) or LaTeX.

[Upcoming Talks](https://arthurdanjou.fr/talks)

###### 2026

- `fr` **Krum, une bibliothèque pour l'agrégation robuste** — _Soutenance M2 ISF, CMAP, École polytechnique_ · [PDF](https://talks-twu.pages.dev/2026/soutenance-m2-krum/slides.pdf)
- `fr` **Robustesse Byzantine dans l'Apprentissage Distribué** — _Séminaire interne CMAP, Ecole Polytechnique_

## Deploy

```sh
./deploy.sh
```

Le script assemble `dist/` à partir de `site/index.html` et des PDF, puis publie
sur le projet Cloudflare Pages `talks`.

Le même déploiement est automatisé par GitHub Actions à chaque push sur
`master`. Le workflow `.github/workflows/deploy.yml` demande deux secrets :
`CLOUDFLARE_API_TOKEN`, avec le droit Cloudflare Pages: Edit, et
`CLOUDFLARE_ACCOUNT_ID`.
