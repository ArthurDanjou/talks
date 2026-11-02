# Krum, une bibliothèque pour l'agrégation robuste

Soutenance de master 2 ISF, Université Paris-Dauphine PSL.
Stage au CMAP, École polytechnique, 2 novembre 2026.

[PDF de la soutenance](https://talks.arthurdanjou.fr/2026/soutenance-m2-krum/slides.pdf)

## Build

```sh
latexmk -pdf slides.tex
```

Le PDF sort à `slides.pdf`. Les auxiliaires sont isolés dans `build/` par
`latexmkrc`. Les figures sont dans `assets/fig/` et les logos institutionnels
dans `assets/header/`.

## Structure

- `slides.tex` contient le préambule et assemble l'exposé.
- `content/` contient les dix fichiers de l'exposé principal et le fichier de
  réserve.
- `assets/` contient les figures et les logos, sans dépendance externe.

## Thème

Le thème reprend les bleus `#01426A` et `#0085CA` de la
[charte graphique de l'École polytechnique](https://www.polytechnique.edu/sites/default/files/content/pages/documents/2022-02/Charte%20graphique%202021%20%C3%89cole%20polytechnique_compressed.pdf).
La couverture utilise les logos Dauphine et CMAP présents dans
`assets/header/`. Le logo Polytechnique est la version RVB du
[kit officiel horizontal](https://www.polytechnique.edu/sites/default/files/content/pages/documents/2022-02/Kit_logo_web_horizontal.zip),
reprise sans modification.

## Notes

- `notes/notes.md` contient la narration et le minutage.
- `notes/texte.md` contient le texte complet de la soutenance.
- `notes/questions.md` classe les questions possibles du jury par intention.
- `notes/ideas-from-report.md` rassemble les notes préparatoires.
