# Texte de la soutenance

Durée indicative de l'ouverture, jusqu'à la slide 2 : 1 min 30 à 2 minutes.

## Slide de titre

Bonjour à toutes et à tous.

Je vais vous présenter le travail que j'ai réalisé pendant mon stage de master 2
au Centre de Mathématiques Appliquées, le CMAP, à l'École polytechnique.

J'ai participé au développement de Krum, une bibliothèque Python destinée à
faciliter les expériences de recherche en apprentissage distribué robuste.
L'idée est d'entraîner un modèle avec plusieurs machines, tout en tenant compte
de participants malhonnêtes qui peuvent chercher à fausser l'entraînement.

## Slide 1. Le CMAP et le groupe Robust Learning

J'ai effectué ce stage dans le groupe Robust Learning, qui étudie la robustesse
de l'apprentissage.

Mon encadrement associait trois rôles complémentaires : El-Mahdi El-Mhamdi pour
les travaux scientifiques, Peva Blanchard pour les priorités du produit et
Sébastien Rouault pour la direction technique. Avec Mohamad-Ammar Said, nous
participions au développement de la bibliothèque.

Le travail se faisait donc à l'interface entre recherche et développement
logiciel. Il fallait comprendre les méthodes publiées, les traduire en code,
et les contributions devaient être relues et approuvées par Peva et Sébastien, ainsi que documentées et testées.

## Slide 2. Le sujet du stage

Pour présenter ce travail, je commencerai par expliquer le contexte scientifique
et le problème auquel répond la bibliothèque. Je présenterai ensuite l'origine
du projet Krum et mes contributions à ses différents composants. Nous verrons
alors les expériences réalisées pour les évaluer, avant de terminer par le bilan
du stage et ses perspectives.

Commençons donc par l'apprentissage supervisé, puis par les raisons qui
conduisent à distribuer l'entraînement.

## Slide 3. Apprentissage supervisé et entraînement distribué

_Repère : 2:00–3:00._

En apprentissage supervisé, on dispose de données pour lesquels la réponse
attendue est connue. Le modèle produit une prédiction à partir d'une entrée.
La fonction de perte, la loss, mesure l'écart entre cette prédiction et la réponse attendue.
L'entraînement consiste à ajuster les paramètres du modèle pour minimiser cette perte sur les données d'entraînement.

Pourquoi distribuer ce calcul ? Il peut dépasser les capacités de calcul d'une seule
machine. Les données doivent rester là où elles sont produites.

Par exemple, plusieurs téléphones peuvent contribuer à un modèle de prédiction
du mot suivant, sans centraliser leurs textes. De même, plusieurs hôpitaux
peuvent entraîner un modèle de diagnostic commun en conservant leurs dossiers
sur place.

Voyons maintenant comment organiser cet entraînement entre plusieurs
participants.

## Slide 4. Un tour d'apprentissage centralisé

_Repère : 3:00–4:15. Suivre le schéma de gauche à droite._

On appelle « worker » un participant qui effectue un calcul sur ses données
locales. Dans le protocole centralisé représenté ici, un serveur conserve le
modèle global et en diffuse les paramètres aux workers.

Chaque worker tire un petit lot de données, appelé mini-batch, et calcule le
gradient de la perte sur ce lot. Ce calcul fournit une estimation du gradient
sur ses données locales. C'est le principe de la descente de gradient
stochastique, ou SGD.

Les workers transmettent leurs gradients au serveur. Celui-ci les combine,
autrement dit les agrège, par exemple en calculant leur moyenne. Il met ensuite
à jour les paramètres du modèle avec l'objectif de réduire la perte.
Le nouveau modèle est diffusé et un autre tour commence.

Dans un protocole décentralisé, il n'y a pas de serveur central. Chaque
participant possède son modèle et le met à jour par des échanges avec ses
voisins.

## Slide 5. Des participants malhonnêtes

_Repère : 4:30–6:00._

Ces protocoles reposent sur une question de confiance : que se passe-t-il si certains
participants cherchent à fausser l'entraînement ?

On distingue ici trois surfaces d'attaque. Un attaquant peut modifier les données
d'entraînement, compromettre le serveur central, ou falsifier les gradients
envoyés par les workers. Mon travail porte sur ce dernier cas : le serveur est
supposé honnête, mais certains workers peuvent envoyer des vecteurs de leur
choix.

C'est le scénario byzantin. Parmi les $n$ workers, au plus $f$ sont malhonnêtes.

Dans le scénario étudié, les attaquants disposent de deux capacités supplémentaires.
La collusion signifie qu'ils peuvent se coordonner pour construire leurs
contributions. L'omniscience signifie qu'ils connaissent l'état du système,
notamment les gradients calculés par les workers honnêtes. Ils peuvent donc
adapter leurs vecteurs à ces informations.

Le serveur doit combiner les vecteurs reçus sans savoir lesquels proviennent de participants malhonnêtes.

## Slide 6. Pourquoi remplacer la moyenne ?

_Repère : 6:00–6:45._

La façon la plus simple et la plus naturelle de combiner les gradients est de calculer leur moyenne.
Mais un seul worker malhonnête peut envoyer un vecteur de très grande amplitude,
dans la direction qu'il choisit. Puisque cette contribution n'est pas bornée,
il peut déplacer la moyenne arbitrairement loin des contributions honnêtes.

Il faut donc remplacer la moyenne par une règle d'agrégation robuste, qui limite
l'impact des attaquants, par exemple en sélectionnant ou en filtrant les
vecteurs reçus.

Ces règles doivent ensuite être implémentées et comparées expérimentalement.
C'est à ce moment-là que le besoin à l'origine de Krum est né.

## Slide 7. Du copier-coller à des composants réutilisables

_Repère : 6:45–7:30._

Le second constat vient de Sébastien. Depuis plusieurs années, il développe du
code pour des articles de recherche. Il avait remarqué que ce code était souvent
repris par copier-coller, sans que son fonctionnement soit toujours bien compris.

Au début du stage, j'ai d'abord audité le code de recherche existant, puis
reproduit des expériences centralisées à partir de zéro. J'ai ainsi constaté
le temps nécessaire pour réimplémenter les mêmes briques et organiser les
expériences.

Ces constats ont permis de préciser la mission du stage : réunir ces composants
dans une bibliothèque Python réutilisable, pour faciliter la reproduction et
la comparaison des expériences publiées.

## Slide 8. Krum : une bibliothèque en trois couches

_Repère : 7:30–8:30._

Notre bibliothèque, Krum, repose sur PyTorch, un outil de calcul et d'entraînement
des modèles. Son nom reprend celui de l'agrégateur proposé en 2017 par Peva et El-Mahdi.

Krum comporte trois couches : les primitives fournissent les briques de calcul,
les simulations exécutent les protocoles, et l'orchestration gère les campagnes
d'expériences.

Dans ce projet collectif, j'ai travaillé sur les agrégateurs, les architectures de modèles et les simulations centralisés.
J'ai entièrement rédigé la documentation et les tutoriels.

Pour rentrer dans l'implémentation technique de Krum, je vais commencer par décrire la couche des primitives.

## Slide 9. Les familles d'agrégateurs

_Repère : 8:30–9:40._

La première famille de primitives que j'ai développée est celle des règles
d'agrégation. Elles reçoivent les gradients calculés par les participants et
produisent le gradient qui servira à mettre à jour le modèle.

Les règles se distinguent par leur façon de traiter les vecteurs. Certaines
sélectionnent des gradients proches les uns des autres. D'autres filtrent
chaque coordonnée séparément. Les règles hybrides combinent plusieurs
mécanismes, tandis que les règles géométriques cherchent un centre des
vecteurs.

Pour comparer ces méthodes, on utilise notamment la moyenne, appelée
`Average`, comme référence. Elle combine tous les gradients, mais ne limite pas
l'effet d'une contribution arbitraire.

## Slide 10. MultiKrum : sélectionner puis moyenner

_Repère : 9:40–10:35._

Je prends l'exemple de MultiKrum, une règle introduite par les encadrants de mon stage.
Pour chaque gradient, on regarde les gradients de ses $n-f-2$ plus proches voisins.
Puis on calcule un score qui correspond à la somme des distances au carré vers ces voisins sélectionnés.

Un score faible signifie que le gradient est proche de plusieurs autres gradients.
MultiKrum sélectionne les $m$ gradients ayant les scores les plus faibles, puis en calcule la moyenne.
Si $m=1$, on retrouve Krum, introduite en 2017 par Peva et El-Mahdi.
Si $m=n$, on retrouve tout simplement la moyenne.

## Slide 11. Deux attaques pour éprouver les agrégateurs

_Repère : 10:35–11:25._

Pour comparer des agrégateurs, il faut savoir les attaquer. Je vais donc vous présenter deux des attaques implémentées,
celles utilisées dans nos expériences que je décrirai plus tard.

Je vais commencer par vous rappeler que nous sommes dans le scénario
d'omniscience : les attaquants connaissent les gradients honnêtes.

Avec `SignFlip`, les attaquants prennent la moyenne honnête, inversent la direction et
augmentent l'amplitude.

`SmallPerturbation` agit autrement. Elle ajoute un décalage sur une seule
coordonnée de la moyenne honnête. L'objectif est de faire passer cette
contribution à travers la règle de sélection.

## Slide 12. Les données locales peuvent aussi différer

_Repère : 11:25–12:00._

Jusqu'ici, nous avons parlé des contributions malhonnêtes. Cependant, même les
participants honnêtes peuvent produire des gradients différents, parce que
leurs données locales ne se ressemblent pas.

Dans le cas IID, les observations sont indépendantes et issues de la même loi.
Dans le cas non IID, les distributions locales peuvent différer. Par exemple,
les hôpitaux peuvent accueillir des populations de patients différentes.

Les partitionneurs servent à répartir les données entre participants et à
contrôler ce degré d'hétérogénéité, afin de mesurer son effet sur les
agrégateurs.

## Slide 13. Ajouter une règle à la bibliothèque

_Repère : 12:00–12:30._

Une autre de mes contributions à la librairie Krum est de rendre ces primitives simples à étendre.

Pour ajouter un nouvel agrégateur, une nouvelle attaque ou un nouveau type de partitionnement, il n'y a qu'une méthode python à implémenter.
En suivant ces interfaces pré-définies, la nouvelle primitive peut être utilisée dans les simulations sans modifier le code d'expérience.

La bibliothèque rassemble au total onze règles d'agrégation, cinq attaques,
quatre partitionneurs et six architectures de modèles prêtes à l'emploi.

## Slide 14. Préparer les modèles pour l'agrégation

_Repère : 13:00–14:00._

La dernière primitive est le wrapper de modèle PyTorch.
PyTorch range les paramètres et les gradients du modèle par couche.
Sauf que les agrégateurs doivent les traiter réunis sous la forme d'une seule couche aplatie comme une suite de nombre.

Le composant `Model` que j'ai développé fait le lien entre PyTorch et les
agrégateurs. Il leur présente les valeurs aplaties sans les recopier. Comme le
montre le schéma, elles partagent la même mémoire.
Cela évite des copies répétées pendant l'agrégation qui peuvent mener à une explosion de la mémoire utilisée.

Je passe maintenant aux simulations, qui assemblent ces
différentes briques que je viens de présenter.

## Slide 15. La simulation prend en charge la boucle d'entraînement

_Repère : 15:00–16:00._

Quand j'ai reproduit des expériences à partir de zéro au début de mon stage, je devais réécrire les
mêmes étapes de la boucle d'entraînement à chaque fois. La simulation vient automatiser cette
partie : l'utilisateur choisit la répartition des données entre participants,
puis le programme forme les mini-lots, calcule les gradients locaux, applique
l'attaque puis l'agrégation, et met à jour le modèle.

## Slide 16. Fidélité des simulations

_Repère : 16:00–17:00._

L'intérêt est de pouvoir changer les paramètres de l'expérience, comme l'attaque ou l'agrégateur,
$n$, $f$, etc, sans réécrire chaque fois toute la boucle spécifique à PyTorch.

Nous parlons de simulations fidèles parce qu'elles conservent les mécanismes
nécessaires pour reproduire le phénomène visé du protocole étudié, tout en
documentant les adaptations faites pour l'expérience.

## Slide 17. L'orchestrateur gère les campagnes

_Repère : 17:00–17:45._

Passons à la dernière couche de la librairie, celle qui gère les campagnes d'expériences : l'orchestrateur.

Pour évaluer une règle d'agrégation, on fait varier plusieurs paramètres de
l'expérience : la règle, l'attaque, le nombre de participants et les graines.
L'orchestrateur lance chaque combinaison et conserve les mesures, comme la
perte et l'exactitude, ou d'autres métriques choisies par l'utilisateur.

Quand on relance une campagne, il n'exécute que les expériences nouvelles,
échouées ou périmées. Un changement de code, de paramètres ou d'environnement
logiciel peut rendre un ancien résultat périmé.

Cette partie a été développée par Sébastien Rouault et Peva Blanchard.

## Slide 18. Tester, documenter et publier la bibliothèque

_Repère : 17:45–18:35._

Je vais maintenant décrire la librairie d'un point de vue logiciel produit.

La librairie en compte plusieurs centaines de tests qui s'exécutent
automatiquement pour vérifier le comportement des composants,
par exemple : le respect des garanties mathématiques.

J'ai entièrement rédigé la documentation et les tutoriels pour expliquer
comment utiliser et étendre la bibliothèque.
La bibliothèque est distribuée sous licence MIT et s'installe simplement et rapidement
avec une seule commande.

Je passe maintenant à la validation des expériences des simulations.

## Slide 19. 2017 : MultiKrum face à la moyenne

_Repère : 19:00–20:00._

La première expérience reprend le protocole de Blanchard et ses coauteurs,
publié en 2017. La question est de savoir si MultiKrum maintient l'apprentissage
lorsque la moyenne échoue.

...

## Slide 20. 2017 : la perte de la moyenne diverge

_Repère : 20:00–21:00._

En haut, on voit la perte de test avec la moyenne attaquée. Elle augmente
jusqu'à ce que les poids du modèle deviennent indéfinis, ou NaN, au tour 60.
En bas figure l'exactitude de test. Elle se stabilise ensuite autour de 60 %,
mais ce chiffre est un artefact : le modèle prédit la classe majoritaire.
Il ne correspond donc plus à une performance valide du modèle.

## Slide 21. 2017 : MultiKrum continue à apprendre

_Repère : 21:00–22:00._

Le graphique du haut zoome sur les pertes de test finies, entre 0,4 et 0,8.
La moyenne attaquée en est exclue puisqu'elle diverge. Le graphique du bas
reprend l'exactitude de test.

Dans cette expérience, MultiKrum atteint environ 77 % d'exactitude sous
attaque, contre 82 % sans attaque. L'apprentissage se poursuit malgré
SignFlip.
Nous retrouvons donc le phénomène attendu et décrit dans le papier de Blanchard & al.

## Slide 22. 2018 : une perturbation peut passer la sélection

_Repère : 22:00–23:20._

La deuxième expérience reprend le protocole d'El-Mhamdi et ses coauteurs,
publié en 2018. Elle teste si une perturbation peut dégrader Krum tout en
restant sélectionnée parmi les contributions honnêtes.

...

Bulyan est soumis à la même attaque : après la sélection,
il filtre chaque coordonnée en retenant les valeurs les plus proches de la médiane.

## Slide 23. 2018 : Krum apprend, puis plafonne

_Repère : 23:20–25:00._

Les courbes montrent la perte de test et l'exactitude finale. Sous la même
attaque, Krum apprend, mais plafonne autour de 90 % d'exactitude. Bulyan
atteint environ 94 %, près des 95 % de la moyenne sans attaque. La perte de
Krum reste également plus élevée.

La perturbation passe la sélection de Krum à chaque tour et dégrade peu à peu
le résultat. On peut donc manquer cette vulnérabilité si l'on regarde
seulement si le modèle continue à apprendre. Dans cette comparaison, Bulyan
est moins affecté que Krum.

## Slide 24. Ce que ces expériences permettent de conclure

_Repère : 25:00–25:30._

Les expériences retrouvent les phénomènes étudiés, à échelle réduite, avec
des adaptations documentées. Chacune s'exécute en moins de trois minutes sur
le processeur classique d'une machine.

À code, graines, matériel et environnement déterministe fixés, les résultats
sont identiques bit à bit.

L'équipe a aussi implémenté MoNNA, un protocole décentralisé publié par
Farhadkhani et ses coauteurs à ICML en 2023. Je n'ai pas contribué à cette
simulation.

_Passer à la comparaison de Krum avec les autres bibliothèques._

## Slide 25. Face à cinq bibliothèques comparables

_Repère : 23:00–25:00._

Après cette validation expérimentale, je voulais situer Krum par rapport aux
bibliothèques déjà disponibles et voir ce qu'elle apporte, mais aussi ce qui
lui manque.

Pour cela, j'ai retenu cinq bibliothèques : ByzFL, FedLab, Blades,
FL-Byzantine-Library et ByzPy. Leur code source est consultable et elles
proposent des composants d'agrégation byzantine comparables.

Le tableau compare quatre aspects. Le catalogue de Krum compte onze règles
d'agrégation et cinq attaques, même si certaines bibliothèques proposent plus
de composants. Le composant `Model` donne accès aux paramètres sans les copier.
Krum documente trois protocoles, tandis que les autres outils comparés sont
plutôt des cadres génériques ou des suites d'outils. Enfin, Krum peut recalculer
les expériences périmées lors d'une relance. ByzFL, dans la version comparée,
saute les exécutions déjà terminées.

Cette comparaison est une photographie datée : les comptes d'août 2026 ont été
audités en septembre. Elle fait ressortir des différences d'usage, pas un
classement global des bibliothèques.

## Slide 26. Les limites actuelles

_Repère : 25:00–26:00._

Grâce à ce tableau comparatif, j'ai pu définir les limites et les manques de notre librairie.

Le catalogue reste ciblé, avec moins de composants implémentés, mais ce sont les plus utilisés du domaine.
Il ne comprend pas les pré-agrégateurs, qui peuvent intervenir avant l'agrégation pour borner les normes ou réduire le bruit.
Les expériences s'exécutent aussi séquentiellement sur une seule machine,
et les échanges entre participants sont simulés.

On évalue donc les protocoles, pas les coûts d'un déploiement distribué réel
car c'est une bibliothèque de recherche, et non de production.

## Slide 27. Mes contributions au projet

_Repère : 26:00–28:00._

Après avoir présenté les limites actuelles de Krum, je voudrais revenir sur
mes contributions au projet et sur les acquis découvert pendant mon stage pour dresser son bilan.

Pour résumer, mon travail a porté sur les agrégateurs, le composant `Model`, les architectures de modèles et
les simulations centralisés. J'ai écrit les tests associés à mes composants et je les ai automatisés.
J'ai entièrement rédigé la documentation et les tutoriels destinés aux utilisateurs.

J'ai également assuré une partie de la rédaction du papier compagnon, puis je l'ai
corrigé et amélioré son contenu avec El-Mahdi El-Mhamdi. Il est encore en cours de rédaction aujourd'hui
et vise la rubrique logiciels libres du _Journal of Machine Learning Research_.

Sur le plan personnel, le stage m'a appris à justifier mes choix et mes décisions d'architectures logicielles et à faire
relire mon code. J'ai commencé à apprendre à lire des articles de recherche et
j'ai découvert le travail de rédaction d'un article scientifique. J'ai également ouvert la porte du monde de l'apprentissage distribué robuste.

## Slide 28. Les acquis du stage et la suite

_Repère : 28:00–29:00._

Le stage a abouti à Krum, une bibliothèque Python qui réunit des composants
réutilisables pour reproduire et comparer des expériences d'agrégation robuste.
J'ai pu mettre en pratique les acquis de l'ISF, des statistiques et de
l'optimisation jusqu'au code testé et à l'analyse des résultats. Le travail
en équipe m'a aussi appris à expliquer et à documenter mes choix.

Je vais poursuivre ce travail en thèse avec la même équipe d'encadrement. J'étudierai les
garanties des agrégateurs pour la sécurité de l'apprentissage, et je pourrai
m'appuyer sur la librairie Krum pour mener des campagnes expérimentales comparables.

Merci à l'équipe et merci de votre attention.
