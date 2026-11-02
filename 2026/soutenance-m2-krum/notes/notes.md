# Soutenance : plan de travail pour 30 minutes

Ces notes accompagnent les slides Beamer du dossier
`2026/soutenance-m2-krum`.
Les numéros cités sont ceux affichés sur les slides de contenu.
Les pages de titre et de transition ne sont pas numérotées.
Le minutage vise 29 minutes de contenu et une minute de marge.

## Fil directeur et attribution des contributions

Message à retenir : « Mon stage a contribué à transformer du code de recherche
en composants réutilisables pour étudier l'agrégation robuste, avec un travail
centré sur les agrégateurs, le composant d'accès sans copie aux modèles,
appelé wrapper, et le cas centralisé. »

L'oral suit quatre étapes : le problème et la mission, la construction de Krum,
la validation expérimentale, puis le bilan du stage.

- Présenter la bibliothèque complète comme un résultat collectif.
- Employer « je » pour mes contributions aux agrégateurs, au wrapper `Model`,
  aux modèles du cas centralisé, ainsi qu'aux tests, à la documentation et
  à l'automatisation des vérifications et de la publication.
- Présenter MoNNA comme un travail de l'équipe auquel je n'ai pas participé,
  y compris pour sa simulation et ses résultats. Garder son graphe en réserve.
- Attribuer l'orchestrateur à Sébastien Rouault et Peva Blanchard.
  Je n'en ai pas modifié le code.
  Expliquer son utilité en moins d'une minute.
- Préciser que j'ai entièrement rédigé la documentation et les tutoriels.
- Faire apparaître mon travail sur la comparaison des bibliothèques et sur
  la rédaction du papier compagnon.

## Déroulé et horloge

1. **0:00–2:00.** Présenter le CMAP, l'équipe et le sujet général du stage.
2. **2:00–6:30.** Poser le contexte scientifique et le problème byzantin.
3. **6:30–8:00.** Expliquer l'origine pratique de Krum, préciser la mission
   et mon périmètre, puis annoncer ses trois couches.
4. **8:00–15:00.** Détailler les primitives et mes contributions techniques.
5. **15:00–17:00.** Présenter les simulations, en privilégiant le cas centralisé.
6. **17:00–17:45.** Expliquer les services de l'orchestrateur.
7. **17:45–19:00.** Présenter les tests, la documentation et la distribution.
8. **19:00–25:30.** Analyser les deux expériences centralisées et préciser leur fidélité.
9. **25:30–27:00.** Comparer Krum aux autres bibliothèques et exposer ses limites.
10. **27:00–29:00.** Conclure sur les contributions, les acquis et la suite.
11. **29:00–30:00.** Conserver cette minute comme marge de présentation.

Repères principaux : commencer les primitives à 8:00, les résultats à 19:00
et le bilan à 27:00. Une répétition chronométrée devra valider ce découpage.
En cas de retard, raccourcir le catalogue et les paramètres secondaires.
Si l'exposé est trop long, ne pas présenter la slide 14, consacrée au wrapper
`Model` et au zéro-copie. Passer directement aux simulations et conserver
ce schéma pour les questions. Cette coupe libère environ deux minutes.
Préserver le temps de lecture des graphes et la conclusion sur les bénéfices du stage.

Sept transitions non numérotées marquent les grandes parties : primitives,
simulations, orchestration, qualité logicielle, expériences, positionnement
et limites, puis bilan et perspectives. Les afficher brièvement, en les
incluant dans les budgets de temps existants.
Les primitives comportent cinq sous-parties visibles dans les titres :
1.1 Agrégateurs, 1.2 Attaques, 1.3 Partitionnement des données,
1.4 Extension des primitives et 1.5 Modèles et zéro-copie.

## Notes de narration

### 1. Le cadre et le sujet du stage

Présenter le Centre de Mathématiques Appliquées de l'École polytechnique en
quelques phrases. Situer le stage dans le groupe Robust Learning, consacré
à l'apprentissage robuste, à l'interface de l'optimisation et des systèmes distribués.

Présenter les rôles : El-Mahdi El-Mhamdi assure l'encadrement scientifique ;
Peva Blanchard définit les priorités du produit ; Sébastien Rouault assure
la direction technique ; Mohamad-Ammar Said et moi participons au développement.
Résumer l'organisation par les tâches suivies, les contributions relues avant
intégration et les vérifications automatiques.

Situer le sujet du stage en une phrase générale : « J'ai participé au
développement de Krum, une bibliothèque destinée à faciliter les expériences
de recherche en apprentissage distribué robuste. »

### 2. Du supervisé au problème byzantin

- Définir l'apprentissage supervisé : ajuster un modèle à partir d'exemples
  pour lesquels la réponse attendue est connue. Introduire la fonction de perte,
  qui mesure l'erreur du modèle.
- Poser la question « Pourquoi distribuer l'entraînement ? » avant les deux
  exemples du clavier et des hôpitaux. Les présenter comme des exemples
  d'apprentissage distribué, avec des données conservées sur les appareils
  ou dans les établissements. Distinguer ces motifs de la tâche supervisée.
- Définir un worker comme un participant qui effectue un calcul local.
  Expliquer SGD, la descente de gradient stochastique : un petit lot de données
  fournit une estimation du gradient de la perte, puis le modèle est mis à jour
  dans la direction opposée à ce gradient.
- Reprendre le schéma centralisé du rapport et lire un tour : diffusion du modèle, calcul des
  gradients locaux, agrégation et mise à jour. Introduire $n$ participants,
  dont $f$ malhonnêtes, et la moyenne comme référence.
- Définir brièvement le protocole décentralisé : les participants échangent
  entre voisins et mettent à jour leurs modèles sans serveur central.
- Situer les trois surfaces d'attaque retenues dans le rapport : données
  d'entraînement, serveur central et contributions envoyées par les workers.
  Délimiter le sujet aux gradients forgés par des participants malhonnêtes,
  capables d'envoyer des vecteurs arbitraires.
- Définir la collusion comme la coordination des attaquants, et l'omniscience
  comme l'accès à l'état du système, notamment aux gradients honnêtes.
- Expliquer sans formule qu'une seule contribution non bornée peut déplacer
  la moyenne arbitrairement. Introduire le besoin d'une règle d'agrégation robuste.

Conserver un pont bref avec la robustesse statistique : la contamination et
le point de rupture offrent des repères au jury. Ici, l'agrégat sert de direction
à une procédure d'optimisation répétée. Expliquer cette exigence en une phrase.
Garder la définition formelle de la résilience $(\alpha,f)$ en réserve.

### 3. Du code de recherche à la bibliothèque Krum

Raconter le constat de Sébastien : son code d'expériences était repris par
copier-coller dans d'autres dépôts, avec une intégration difficile et des
adaptations susceptibles d'en modifier le comportement. L'audit initial
et les reproductions menées de zéro ont rendu ces difficultés concrètes.
SignGuard peut illustrer ce travail préparatoire sur le cas centralisé.

Expliquer le besoin : réutiliser des règles et des attaques, reproduire des
protocoles, puis explorer de nombreuses combinaisons de paramètres.

Énoncer alors la mission initiale : « La mission du stage était donc de réunir
dans une bibliothèque Python les composants nécessaires pour reproduire
et comparer ces expériences. »

Présenter Krum, bibliothèque Python fondée sur PyTorch, l'outil de calcul
et d'entraînement des modèles. Son nom reprend celui de la règle introduite
dans l'article de 2017, dont Peva et El-Mahdi sont coauteurs.

Préciser mon périmètre : « Dans ce projet collectif, je me suis concentré
sur les agrégateurs, le composant d'accès aux modèles sans copie et le cas
centralisé. J'ai aussi entièrement rédigé la documentation et les tutoriels. »
Les deux architectures ont été définies dans le contexte scientifique.

Annoncer les trois couches : les primitives fournissent les briques de calcul,
les simulations exécutent les protocoles et l'orchestration gère les campagnes de reproduction.

### 4. Les primitives et mes contributions techniques

Consacrer l'essentiel du détail aux agrégateurs et au wrapper. Pour chaque
choix, relier la difficulté rencontrée, la solution et son intérêt expérimental.

**Les agrégateurs.** Présenter les grandes familles par leur mécanisme :
sélection selon les distances, filtrage coordonnée par coordonnée et règles
combinant plusieurs filtrages. Situer les règles géométriques sans toutes les énumérer.
Présenter `Average` comme la moyenne de référence, puis expliquer MultiKrum.

Pour la variante de la bibliothèque, noter $\mathcal N_i$ les $n-f-2$ voisins
les plus proches du gradient $g_i$, parmi les autres gradients. Le score est

$$
s_i=\sum_{j\in\mathcal N_i}\lVert g_i-g_j\rVert^2.
$$

Si $I_m$ contient les indices des $m$ plus petits scores, la sortie est

$$
\operatorname{MultiKrum}(g_1,\ldots,g_n)
=\frac{1}{m}\sum_{i\in I_m}g_i.
$$

Krum correspond à $m=1$. Dans cette implémentation, les scores sont calculés
en une seule passe. La différence avec la sélection itérative décrite dans
la publication est documentée et peut être développée en réponse aux questions.
Réserver l'explication du filtrage de Bulyan à la deuxième expérience.

**Les attaques et les données.** Rappeler SignFlip, qui inverse et amplifie
un gradient. Introduire SmallPerturbation, qui décale une seule coordonnée,
car elle intervient dans la deuxième expérience. Rappeler explicitement le
scénario d'omniscience : les attaquants ont accès aux gradients honnêtes.
ALIE, qui construit un vecteur
à partir de la moyenne et de la dispersion des gradients honnêtes, reste un
exemple facultatif. Définir IID comme des observations indépendantes et de même
loi. Expliquer que les données locales peuvent suivre des lois différentes,
par exemple lorsque les établissements accueillent des populations différentes.
Les partitionneurs permettent de contrôler cette hétérogénéité.

**L'extension de la bibliothèque.** Expliquer « sans état » : une primitive
ne conserve pas de mémoire propre entre deux appels ; ses paramètres sont
fournis à chaque appel. Ajouter un agrégateur demande une seule fonction de
calcul, `aggregate`, conforme à l'interface commune. Les attaques suivent
le même principe avec `generate`, les partitionneurs avec `partition`.
Cette interface permet de réutiliser une nouvelle brique dans les simulations
et les campagnes sans réécrire leurs boucles d'exécution.

**Le wrapper zéro-copie.** Définir un tenseur comme un tableau de nombres
à plusieurs dimensions. PyTorch organise les paramètres et les gradients
en tenseurs par couche, tandis que les agrégateurs travaillent sur des vecteurs.
Un aplatissement, ou flatten, représente ces valeurs sous forme d'un seul vecteur.
Une construction naïve par concaténation peut recopier l'ensemble à chaque tour.
Montrer avec un schéma comment `Model` expose une vue plate partageant la mémoire
des tenseurs du modèle. Les lectures et les écritures passent par cette mémoire
commune, après sa mise en place initiale. Le bénéfice concerne les copies d'accès
aux paramètres et aux gradients ; l'entraînement garde ses autres coûts.

Terminer par l'étendue du catalogue collectif : onze règles, cinq attaques,
quatre partitionneurs et six architectures prêtes à l'emploi. Distinguer ces
comptes globaux des composants que j'ai personnellement développés.

### 5. Les simulations, avec un accent sur le centralisé

Partir du travail répétitif observé lors des reproductions : organiser les
données, tirer les petits lots, calculer les gradients et écrire la boucle
d'entraînement. Expliquer comment les simulations prennent en charge ces étapes.
Le code utilisateur répartit les données entre workers ; la simulation découpe
ensuite leurs données en lots et applique le protocole choisi.

Citer les trois protocoles disponibles dans le projet collectif : Blanchard
et al. (NeurIPS 2017), El-Mhamdi et al. (ICML 2018) et MoNNA de Farhadkhani
et al. (ICML 2023). Détailler les deux protocoles centralisés en lien avec mon
travail. Présenter MoNNA en une phrase comme la couverture décentralisée
développée par l'équipe. Son implémentation et ses résultats restent en réserve.

Définir ici une simulation fidèle : elle conserve les mécanismes nécessaires
à l'étude du phénomène visé et documente les adaptations. Définir une graine
comme une valeur initialisant les tirages pseudo-aléatoires. Préparer ainsi
la distinction entre fidélité au protocole et répétabilité de l'exécution.

### 6. L'orchestration, présentée par ses services

Définir un balayage comme une campagne qui fait varier plusieurs paramètres.
Donner un exemple : croiser les règles, les attaques, le nombre de participants
et les graines multiplie rapidement le nombre d'expériences.

Formulation possible : « L'orchestrateur permet de lancer ces campagnes,
de conserver les résultats et de collecter les mesures, comme la perte et
l'exactitude. Lorsqu'on relance une campagne, seules les expériences nouvelles,
échouées ou devenues périmées sont exécutées. Cette partie a été développée
par Sébastien Rouault et Peva Blanchard. »

Préciser que des résultats deviennent périmés après un changement du code,
des paramètres ou de l'environnement logiciel. S'en tenir à ces services.
La file d'attente et les fonctions internes ne nécessitent pas d'explication
dans le corps de l'oral. La relance concerne une expérience entière ; elle
ne signifie pas nécessairement reprendre l'entraînement au dernier tour sauvegardé.

### 7. Les tests, la documentation et la distribution

Présenter plusieurs centaines de tests automatiques. Relever le décompte exact
sur la version présentée avant de l'inscrire dans les slides. Expliquer que les
tests vérifient les comportements attendus et la conformité des implémentations.
Ils complètent les résultats théoriques et les expériences.

Présenter mes tests et préciser que j'ai entièrement rédigé la documentation
et les tutoriels. Présenter aussi les configurations d'intégration et de
déploiement continus. Expliquer que
ces dernières automatisent les vérifications du code et la publication du paquet.
La documentation explique l'utilisation et l'extension des composants.
La bibliothèque est distribuée sous licence MIT et s'installe avec
`pip install krum`. Cette commande donne accès aux trois couches.

### 8. Deux expériences centralisées, deux questions

Conserver la structure de l'ancien plan : poser une question, donner les
paramètres indispensables, laisser lire la figure et formuler une conclusion.
Consacrer environ trois minutes à chaque expérience, puis trente secondes
à leur portée. Les détails complets des paramètres restent dans le rapport.

**2017 : MultiKrum résiste-t-il là où la moyenne échoue ?**

- Présenter Spambase comme une classification binaire de courriels à partir
  de 57 variables. Utiliser un perceptron, un réseau de couches entièrement
  connectées, avec deux couches cachées de 20 neurones.
- Donner les paramètres essentiels : $n=20$, $f=6$, SignFlip d'amplitude 10,
  300 tours et graine 42. Le découpage est IID et le pas vaut $0{,}01$.
- Préciser $m=n-f=14$. Ce choix est hors de la borne théorique $m\leq5$
  rappelée dans le mémoire. Le résultat est une observation expérimentale
  dans ce protocole adapté.
- Présenter à la fois la perte test et l'exactitude test sur la slide 20.
  Sous attaque, la moyenne diverge. Son palier d'exactitude vers 60 % après
  le tour 60 est un artefact de classe majoritaire avec des poids devenus
  indéfinis ; il ne traduit pas un apprentissage qui se poursuit.
- Sur la slide 21, présenter la perte test avec son échelle resserrée et
  reprendre l'exactitude test. MultiKrum poursuit son apprentissage et atteint
  environ 77 % sous attaque contre 82 % pour la référence saine.

**2018 : une attaque discrète peut-elle dégrader Krum malgré sa sélection ?**

- Présenter MNIST comme une classification d'images de chiffres manuscrits.
  Donner $n=39$, $f=9$, 300 tours, une graine de 42 et SmallPerturbation
  d'amplitude $\gamma=4$. MultiKrum utilise $m=1$, donc Krum.
- Expliquer le mécanisme : un vecteur proche des contributions honnêtes
  peut être sélectionné tout en décalant une coordonnée à chaque tour.
  Bulyan ajoute un filtrage coordonnée par coordonnée après sa sélection.
- Comparer à la référence saine : Krum plafonne vers 90 % d'exactitude,
  Bulyan atteint environ 94 % et la référence environ 95 %. La perte de
  Krum reste aussi plus élevée. La dégradation peut passer inaperçue
  si l'on regarde seulement le fait que le modèle apprend.

**Ce que ces résultats établissent.** Les expériences retrouvent les phénomènes
visés à échelle réduite, chacune en moins de trois minutes sur CPU, le processeur
classique de la machine. Les adaptations des modèles, des données, des attaques
et des paramètres sont documentées. La bibliothèque collective comprend aussi
une troisième étude de cas, MoNNA, qui ne fait pas l'objet d'une analyse ici.

Dans l'environnement déterministe documenté, à code, graines et matériel fixés,
deux exécutions sont bit à bit identiques. Cette répétabilité se distingue de
la fidélité aux mécanismes publiés. Les courbes présentées ne démontrent pas
une stabilité statistique sur plusieurs graines ni une garantie générale de convergence.

### 9. Le positionnement et les limites

Expliquer mon travail de sélection, d'analyse et de décompte pour la comparaison.
Nommer ByzFL, FedLab, Blades, FL-Byzantine-Library et ByzPy. Le critère est leur
comparabilité : du code ouvert pour l'agrégation byzantine et un catalogue
identifiable de composants. Situer les comptes à la date de l'étude du rapport.

Choisir quelques critères lisibles : composants disponibles, accès aux modèles,
protocoles et services d'orchestration. Expliquer les forces de Krum, notamment
l'interface commune, le zéro-copie et les protocoles documentés, puis ses limites :
catalogue plus restreint, absence de certains filtres préalables à l'agrégation
et exécution séquentielle sur une seule machine. Les échanges entre workers
sont simulés ; la bibliothèque ne déploie pas ici un réseau réel de machines.

### 10. Le bilan, les acquis et la suite

Reprendre le message initial sur les composants réutilisables. Rappeler mes
contributions et leur lien avec la mission initiale.
Mentionner le papier compagnon en cours de rédaction, destiné à la rubrique
consacrée aux logiciels libres d'apprentissage automatique du JMLR, Journal
of Machine Learning Research. Présenter ma contribution à sa rédaction
et les corrections menées avec El-Mahdi.

Consacrer un vrai temps aux bénéfices personnels : passage des mathématiques
au code testé, travail en équipe avec relecture, documentation des choix et
écriture scientifique. Relier ces acquis à la formation ISF.

Ouvrir brièvement sur la thèse dans le cadre de la chaire ATLAS : utiliser
Krum pour étudier les garanties des agrégateurs et mener des campagnes
expérimentales comparables. Garder le détail des futurs axes en réserve.
Terminer par le bilan des travaux et les bénéfices du stage, puis remercier.

## Éléments à garder en réserve

- Garder le graphe MoNNA et ses paramètres, avec une attribution collective explicite.
- Préparer la définition complète de la résilience $(\alpha,f)$, les hypothèses
  et les bornes des règles présentées.
- Garder les catalogues exhaustifs, ALIE et TrimmedMean, la moyenne qui retire
  les valeurs extrêmes de chaque coordonnée avant de moyenner les autres.
- Préparer les variantes documentées de MultiKrum et Bulyan, ainsi que les
  paramètres détaillés et la calibration de SmallPerturbation.
- Garder les perspectives détaillées : filtres préalables, coefficient de
  robustesse $\kappa^\star$, signSGD, attaques sur les données et exécution parallèle.

## Questions à préparer pour le jury

Une banque plus complète de questions et de pistes de réponse est disponible
dans [questions.md](questions.md).

1. **Quelle est ma contribution personnelle ?** Reprendre la répartition annoncée
   avec la mission et distinguer les composants développés, les travaux collectifs
   et le code préexistant de Sébastien.
2. **Que signifie la résilience $(\alpha,f)$ ?** Elle impose notamment une
   orientation moyenne de l'agrégat compatible avec le gradient réel et un
   contrôle de ses moments. Les conclusions de convergence dépendent aussi
   des hypothèses sur le bruit et les pas d'apprentissage.
3. **Pourquoi utiliser $m=14$ hors de la borne théorique ?** Le réglage reprend
   celui de la figure de référence discutée dans le mémoire. L'expérience
   étudie un phénomène empirique ; elle ne vérifie pas les conclusions d'un
   théorème dont toutes les hypothèses seraient satisfaites.
4. **Que montre une graine fixée ?** Elle permet de répéter les tirages.
   La répétabilité suppose aussi un environnement déterministe. Évaluer
   la variabilité des résultats demande plusieurs graines et une analyse dédiée.
5. **Le zéro-copie supprime-t-il tous les coûts mémoire ?** Il permet de partager
   la mémoire entre les vues plates et les tenseurs du modèle. Les calculs
   de gradients et d'agrégation conservent leurs propres besoins mémoire.
6. **Pourquoi parler de MoNNA et de l'orchestrateur ?** Ils situent mes
   contributions dans le projet complet. Leurs auteurs sont identifiés
   et leur fonctionnement interne ne constitue pas le cœur de mon exposé.
7. **Quel est l'apport des tests ?** Ils détectent des erreurs d'implémentation
   et des régressions sur les propriétés vérifiées. Les démonstrations
   mathématiques et les expériences apportent des éléments complémentaires.

## Préparation des slides et du jour de la soutenance

- Construire les slides à partir de ce récit, puis adapter leur nombre au rythme réel.
- Définir les termes Python et les termes du domaine à leur première utilisation.
- Faire apparaître les références des publications et la date de la comparaison.
- Vérifier les chiffres, le nombre de tests et la version de la bibliothèque présentée.
- Répéter à voix haute avec un chronomètre et préserver la minute de marge.
- Vérifier la lisibilité des graphes et des formules sur la machine de projection.

Les slides utilisent une présentation Beamer institutionnelle sur fond blanc,
avec les bleus de l'École polytechnique. Les références
y sont citées en clair et les figures sont lues dans `assets/fig/`.
La compilation depuis le dossier `2026/soutenance-m2-krum` reste :

```sh
latexmk -pdf slides.tex
```

Le PDF est produit dans `slides.pdf`, à la racine de ce dossier.
