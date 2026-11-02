# Questions du jury : sept types, et comment y répondre

Ces formulations servent à s'entraîner, pas à réciter. Les numéros permettent
les renvois internes.

Une soutenance ne teste pas la restitution du plan. Le jury a entendu trente
minutes d'exposé et dispose de quelques minutes pour vérifier une seule chose :
savez-vous ce que vous avez fait, et où s'arrête ce que vous pouvez en dire ?

Les questions se ramènent à sept intentions, et chacune appelle une forme de
réponse différente. Reconnaître l'intention évite les deux fautes les plus
coûteuses : répondre à côté et répondre trop longtemps.

Le jury est un professeur de mathématiques, peu familier de Python et de
l'apprentissage fédéré byzantin. Il demandera donc souvent une définition avant
de discuter, il distinguera spontanément le démontré de l'observé, et il
vérifiera que le périmètre annoncé correspond au travail présenté.

Forme générale d'une réponse : le résultat en une phrase, la justification en
une ou deux phrases, la limite en une phrase. Trente secondes suffisent. Le
développement ne vient que si le jury le demande.

| Type | Question typique | Ce que le jury vérifie | Réponse visée |
|---|---|---|---|
| 1. Définir et distinguer | « Qu'est-ce que la résilience $(\alpha,f)$ ? » | Le vocabulaire est-il maîtrisé, sans confusion entre deux notions | 20 à 30 s |
| 2. Expliquer le mécanisme | « Comment Krum sélectionne-t-il ? » | La compréhension réelle, pas la récitation d'un nom | 30 à 40 s |
| 3. Séparer le prouvé, le mesuré et le supposé | « Votre expérience prouve-t-elle que… ? » | La rigueur du raisonnement | 30 s |
| 4. Sonder les limites | « Où est-ce que cela casse ? » | La lucidité sur le travail | 25 à 30 s |
| 5. Contrôler la méthode | « Une graine suffit-elle ? » | La validité des conclusions expérimentales | 30 à 40 s |
| 6. Établir la contribution | « Qu'avez-vous fait vous-même ? » | L'authenticité et le respect de la consigne ISF | 30 s |
| 7. Situer et projeter | « Et ensuite ? » | La culture du domaine et le recul | 25 à 30 s |

## 1. Définir et distinguer

Le jury veut savoir si le mot employé recouvre une notion précise. Donner la
définition, l'objet auquel elle s'applique, puis la distinction qui compte. Une
définition qui ne nomme aucune propriété vérifiable ne répond pas.

### 1.1 En quoi le problème byzantin diffère-t-il d'un simple bruit dans les gradients ?

Un gradient honnête varie déjà à cause des données et de l'échantillonnage.
Le modèle byzantin ajoute jusqu'à $f$ participants qui peuvent envoyer des
vecteurs arbitraires, se coordonner et, dans le scénario étudié, connaître les
gradients honnêtes. La première source de variation est statistique et centrée,
la seconde est adversariale et peut être arbitrairement orientée.
L'agrégateur doit distinguer ces deux sources.

### 1.2 Que signifie la résilience $(\alpha,f)$ ?

Elle impose que l'espérance de l'agrégat garde une composante positive dans la
direction du vrai gradient, contrôlée par le paramètre $\alpha$. Elle contrôle
aussi les moments d'ordre 2 à 4 de l'agrégat. Pour en déduire une convergence, il
faut en plus des hypothèses sur le bruit honnête et sur les pas d'apprentissage.

*Slide de réserve : « Modèle de menace et résilience ».*

### 1.3 Que voient les attaquants dans les expériences ?

Le scénario peut être omniscient : les attaquants connaissent les gradients
honnêtes et peuvent se coordonner. C'est une hypothèse volontairement forte
pour éprouver les règles. Les paramètres exacts dépendent de l'attaque :
SignFlip inverse la moyenne honnête, ALIE utilise ses statistiques et
SmallPerturbation vise la frontière de sélection d'un agrégateur.

*Slides de réserve : « Notations des attaques : gradients honnêtes et statistiques »
et « Notations des attaques : négation et perturbation ».*

### 1.4 Le serveur est-il supposé honnête ?

Oui. Le modèle de menace porte sur les contributions des workers : au plus $f$
d'entre eux peuvent envoyer des vecteurs arbitraires, coordonnés et dépendants
des gradients honnêtes. Une compromission du serveur est une autre surface
d'attaque, hors du périmètre étudié. Les résultats ne disent donc rien sur un
serveur malveillant.

*Slide de réserve : « Modèle de menace et résilience ».*

## 2. Expliquer le mécanisme

Décrire l'entrée, l'opération, la sortie, puis l'effet du paramètre qui fait
débat. Le jury ne veut pas le code, il veut la chaîne causale. Si un nom de
classe Python vient spontanément, le garder pour la fin.

### 2.1 Quelle différence entre Krum, MultiKrum et Bulyan ?

Krum renvoie un gradient dont le voisinage est proche. MultiKrum moyenne
plusieurs gradients ayant les meilleurs scores. Bulyan combine une sélection
par distances avec un filtrage coordonnée par coordonnée, qui écarte les
valeurs les plus éloignées de la médiane.

*Slide de réserve : « Notations des agrégateurs : distances et filtrage ».*

### 2.2 Pourquoi Krum regarde-t-il $n-f-2$ voisins ?

Le voisinage est pris parmi les $n-1$ autres gradients, et sa taille vient de
la preuve. Elle garantit que, même si les $f$ vecteurs malhonnêtes y figurent
tous, il en reste au moins $n-2f-2$ honnêtes, quantité strictement positive dès
que $n>2f+2$. C'est la condition de garantie rappelée avec la définition.

### 2.3 Pourquoi Krum est-il vulnérable à SmallPerturbation alors qu'il sélectionne un voisinage ?

La perturbation est construite pour rester assez proche des gradients honnêtes
pour passer la sélection. Elle décale pourtant une coordonnée à chaque tour.
Bulyan ajoute ensuite un filtrage coordonnée par coordonnée, qui peut retirer
cette valeur extrême.

### 2.4 Pourquoi Bulyan filtre-t-il coordonnée par coordonnée ?

Une sélection par distances compare des vecteurs entiers. Un vecteur peut donc
rester proche du groupe honnête tout en portant une valeur extrême sur une
seule coordonnée, et cette coordonnée dérive à chaque tour. Le filtrage
coordonnée par coordonnée traite chaque dimension séparément et écarte les
valeurs les plus éloignées de la médiane, ce qui supprime ce décalage local.
C'est le mécanisme qui explique l'écart observé dans la deuxième expérience.

### 2.5 Comment SmallPerturbation choisit-elle son amplitude ?

Dans la bibliothèque, elle part de la moyenne honnête et retient le plus grand
décalage qui reste sélectionné par l'agrégateur visé, ce qui suppose de
connaître sa règle de sélection ; la recherche est bornée à
$\gamma_{\max}=10^{6}$. Dans l'expérience de 2018, l'amplitude est fixée à
$\gamma=4$, valeur mesurée sous la frontière au tour 0, pour alléger
l'exécution. Par défaut, la direction est la coordonnée de plus forte variance
honnête.

*Slide de réserve : « Notations des attaques : négation et perturbation ».*

### 2.6 Qu'apporte le wrapper `Model` sans copie ?

Il expose paramètres et gradients sous forme de vecteurs tout en partageant la
mémoire avec les tenseurs par couche. Cela évite les copies répétées lors de
l'accès à ces valeurs ; sur le protocole de 2018, l'ordre de grandeur est de
12 000 copies intégrales par expérience. Cela ne supprime ni le calcul des
gradients ni les autres coûts mémoire de l'entraînement.

## 3. Séparer le prouvé, le mesuré et le supposé

C'est le type le plus probable avec un jury de mathématiques. Répondre en trois
temps : les hypothèses du résultat cité, ce que le réglage respecte, ce que la
courbe établit. Ne jamais laisser entendre qu'une expérience démontre un
théorème.

### 3.1 Que démontrent exactement les deux expériences ?

Elles reproduisent à échelle réduite deux phénomènes ciblés : la moyenne peut
diverger sous SignFlip, et une perturbation discrète peut dégrader Krum tandis
que Bulyan la filtre mieux dans le réglage testé. Elles ne prouvent ni une
garantie générale ni la supériorité universelle d'une règle.

*Slide de réserve : « Ce que montrent les deux expériences ».*

### 3.2 Pourquoi utiliser $m=14$ alors que la borne vaut $m\leq5$ ?

Ce réglage reprend la configuration expérimentale de référence, celle de la
figure du papier. La borne de garantie vaut $m\leq n-2f-3=5$ pour $n=20$ et
$f=6$, et le papier lui-même place ce réglage hors borne. Il permet de comparer
les trajectoires dans ce scénario, mais le résultat observé ne valide pas le
théorème dans ses hypothèses.

*Slide de réserve : « Ce que montrent les deux expériences ».*

### 3.3 L'implémentation suit-elle exactement les publications ?

Pas pour toutes les règles. MultiKrum calcule les scores une seule fois, alors
que la construction publiée sélectionne itérativement avec recalcul. Bulyan
retient $n-2f-2$ candidats au lieu de $n-2f$. Ces écarts sont documentés et
doivent être pris en compte lorsqu'on interprète les garanties.

*Slide de réserve : « Écarts entre publication et implémentation ».*

### 3.4 Peut-on encore parler des garanties pour ces variantes ?

Pas automatiquement. Une garantie démontrée pour une définition ne couvre pas
une variante dont la sélection change. C'est pourquoi je présente les courbes
comme la caractérisation des variantes codées, et les écarts comme un résultat
de l'audit, pas comme un détail d'implémentation.

### 3.5 Par rapport à quel gradient parle-t-on de convergence ?

La garantie compare l'espérance de l'agrégat au vrai gradient, c'est-à-dire à
l'espérance du gradient de la perte sur la distribution des données. Ce
gradient n'est pas observable. Les expériences mesurent donc la perte et
l'exactitude de test, qui sont des indicateurs indirects. Une courbe qui
descend ne démontre pas la résilience au sens $(\alpha,f)$ ; elle montre que
l'entraînement progresse dans ce réglage.

### 3.6 Avez-vous démontré un résultat mathématique ?

Non. Le travail est d'ingénierie logicielle et de validation expérimentale. Les
garanties citées viennent des articles reproduits. Ce que j'ai vérifié
personnellement, ce sont des comportements d'implémentation, par les tests, et
la reproduction de phénomènes publiés, par les expériences. La thèse visera
précisément l'étude des garanties.

### 3.7 Les tests remplacent-ils les garanties mathématiques ?

Non. Ils détectent des erreurs d'implémentation et vérifient les comportements
attendus. Les garanties mathématiques dépendent de leurs hypothèses, tandis que
les expériences examinent des scénarios particuliers. Ces trois éléments se
complètent.

## 4. Sonder les limites

Nommer la limite sans la minimiser, dire ce qu'elle empêche de conclure, puis ce
qui la lèverait. Une limite reconnue et circonscrite inspire plus de confiance
qu'une défense.

### 4.1 Pourquoi se concentrer sur les contributions des workers ?

Le stage étudie la robustesse de l'agrégation face aux mises à jour
malveillantes. L'empoisonnement des données et l'attaque du serveur sont
d'autres surfaces, mais elles ne font pas partie du périmètre expérimental
présenté.

### 4.2 Pourquoi ne pas déployer les workers sur plusieurs machines ?

Le périmètre présenté est la comparaison contrôlée des règles et des attaques.
Les échanges sont simulés et l'exécution est séquentielle sur une machine.
Un déploiement distribué introduirait les délais réseau et les pannes réelles,
qui constituent une autre étape de travail.

*Slide de réserve : « Fidélité, répétabilité et portée ».*

### 4.3 Quelle est la limite la plus sérieuse du travail ?

La plus sérieuse pour les conclusions est la variabilité non mesurée : une seule
graine par configuration, donc les écarts entre règles restent descriptifs.
Viennent ensuite deux limites fonctionnelles : l'absence de pré-agrégateurs,
qui bornent les normes ou réduisent le bruit avant l'agrégation, et l'exécution
séquentielle sur une machine, qui relève du déploiement plus que de l'étude des
règles.

### 4.4 Pourquoi ne pas avoir implémenté davantage de règles ?

Le catalogue couvre les familles utiles aux deux reproductions et à la
comparaison : sélection par distances, filtrage coordonnée par coordonnée,
voisinage, méthodes géométriques, soit onze règles. Les pré-agrégateurs
manquent, mais aucun des trois protocoles rejoués n'en emploie : leur absence
est un choix assumé. L'architecture ne fixe pas la limite, car ajouter une
règle demande une seule méthode. La limite est le périmètre du stage, pas la
conception.

### 4.5 Votre bibliothèque est-elle utilisée en dehors de l'équipe ?

Je ne peux pas présenter de mesure d'adoption. Le paquet est publié sous licence
MIT et s'installe avec `pip install krum`, la documentation et les tutoriels
visent un usage externe, et le papier compagnon est en cours de rédaction pour
la rubrique logiciels du JMLR. C'est un objectif, pas un résultat à ce stade.

## 5. Contrôler la méthode

Décrire la variable contrôlée, la variable qui change, et ce qui reste
confondu. Puis indiquer l'expérience qui trancherait. C'est le type où une
réponse honnête sur une faiblesse vaut mieux qu'une affirmation de plus.

### 5.1 Une graine fixe suffit-elle à établir la reproductibilité statistique ?

Non. Elle permet de répéter les mêmes tirages dans l'environnement déterministe
documenté. Mesurer la variabilité demanderait plusieurs graines, puis une
analyse statistique des résultats.

*Slide de réserve : « Fidélité, répétabilité et portée ».*

### 5.2 Comment distinguer l'hétérogénéité des données d'une attaque ?

Des données non IID font varier les gradients honnêtes parce que les
participants n'observent pas les mêmes distributions. Une attaque ajoute des
contributions construites par un participant malveillant. Les expériences
doivent donc préciser le partitionnement des données, y compris quand aucune
attaque n'est appliquée.

### 5.3 Pourquoi le découpage est-il IID dans les deux expériences ?

Parce que les protocoles reproduits le spécifient. Le découpage IID isole
l'effet de l'attaque : les gradients honnêtes varient, mais tous suivent la
même loi. La bibliothèque fournit des partitionneurs non IID pour l'étude de
l'hétérogénéité, qui est un facteur distinct et ferait l'objet d'une expérience
séparée. Les résultats présentés ne disent donc rien de l'effet conjoint d'une
attaque et d'un partage non IID.

### 5.4 Comment savez-vous que Bulyan est meilleur, et pas seulement mieux réglé ?

Les deux règles voient les mêmes données, la même attaque, la même
initialisation, la même graine et le même calendrier ; seule la règle
d'agrégation change. Cela écarte un effet de réglage propre à chaque règle.
Deux limites subsistent : une seule graine, donc aucun intervalle de confiance,
et des mécanismes différents par construction, une sélection unique pour Krum,
une sélection puis un filtrage par coordonnée pour Bulyan. La conclusion porte
donc sur ces configurations comparées, pas sur les règles en général.

### 5.5 D'où viennent les hyperparamètres ?

Des protocoles publiés lorsqu'ils les précisent et, lorsqu'un paramètre n'y
figure pas, des références du laboratoire, comme les tailles cachées du
perceptron. La comparaison ne cherche donc pas l'optimum de chaque règle ;
elle reproduit un réglage commun. C'est le prix de la fidélité au protocole.

### 5.6 Comment les bibliothèques comparées ont-elles été choisies ?

La comparaison retient des bibliothèques avec du code ouvert et des règles
d'agrégation byzantine suffisamment identifiables pour être analysées. Les
comptes et les fonctionnalités décrivent l'état observé aux dates indiquées
dans le mémoire, pas un classement absolu.

## 6. Établir la contribution

Séparer trois cercles : ce qui existait avant, ce qui est collectif, ce qui est
personnel. Être précis sur le périmètre et ne pas revendiquer le travail des
autres. La consigne ISF valorise explicitement cette distinction.

### 6.1 Quelle est votre contribution personnelle dans un projet collectif ?

Ma contribution porte principalement sur les agrégateurs, le wrapper `Model`,
les modèles et les simulations centralisés, ainsi que les tests, la
documentation et les tutoriels. MoNNA et l'orchestrateur sont des contributions
collectives auxquelles je n'attribue pas mon travail personnel.

### 6.2 Qu'est-ce que vous n'avez pas fait ?

L'orchestrateur a été développé par Sébastien Rouault et Peva Blanchard. MoNNA
et la simulation décentralisée sont un travail de l'équipe, y compris ses
résultats. Le catalogue complet est collectif, et j'en ai développé une partie.
Mon périmètre est celui que j'ai annoncé, et il ne couvre ni le décentralisé ni
la gestion des campagnes.

### 6.3 Pourquoi parler de MoNNA et de l'orchestrateur ?

Ils situent mes contributions dans le projet complet. Leurs auteurs sont
identifiés et leur fonctionnement interne ne constitue pas le cœur de mon
exposé.

### 6.4 Qu'est-ce qui a été le plus difficile ?

Distinguer un écart assumé d'une erreur d'implémentation. En repartant des
articles pour reproduire les expériences, certains comportements ne
correspondaient pas au texte, et il fallait décider si le code était fautif ou
si la variante était documentée. Ce travail d'audit a ensuite structuré la
documentation des écarts. La difficulté du zéro-copie était réelle, mais elle se
vérifiait par des tests ; celle-là se tranchait par la lecture des articles.

## 7. Situer et projeter

Donner le critère de comparaison avant le classement, puis une position datée.
Pour la suite, proposer une expérience testable plutôt qu'un programme vague.
Le jury juge la capacité à prioriser.

### 7.1 Comment Krum se situe-t-elle face aux autres bibliothèques ?

Le tableau compare quatre aspects : catalogue, accès aux modèles, protocoles
documentés, relance des expériences périmées. Krum a un catalogue plus
restreint, mais une interface commune, l'accès sans copie et trois protocoles
reproduits. Ce n'est pas un classement : les autres outils sont des cadres
génériques ou des suites d'outils, et les comptes datent de l'étude.

### 7.2 En quoi Krum est-elle différente au-delà du nombre de composants ?

Quatre choix. Une interface sans état, où ajouter une primitive demande une
seule méthode. Un accès aux paramètres et gradients sans copie. Des protocoles
publiés documentés, avec leurs adaptations. Et une relance qui ne réexécute que
les expériences nouvelles, échouées ou périmées. La limite symétrique est un
catalogue plus restreint et l'absence de pré-agrégateurs.

### 7.3 Quelle serait la suite scientifique du travail ?

Une suite consiste à utiliser Krum pour étudier les garanties et les limites
des agrégateurs sous des hypothèses variées. Les pistes comprennent les
pré-agrégateurs, d'autres attaques et une exécution parallèle. Il faudrait
évaluer ces extensions séparément avant d'en tirer des conclusions.

### 7.4 Quelle serait la première expérience à ajouter ?

Une campagne multi-graines sur la comparaison de 2018, avec une analyse de la
variabilité. C'est le point faible actuel : les écarts entre Krum et Bulyan sont
observés sur une seule exécution. Tant que cette variabilité n'est pas mesurée,
l'écart reste une observation. Les pré-agrégateurs viendraient ensuite, parce
qu'ils changent les garanties et méritent leur propre protocole.

## Quand la question contient déjà une thèse

Certaines questions affirment une erreur ou une généralité pour voir si elle est
acceptée. Corriger le présupposé avant de répondre, sinon la réponse le valide.

### « Pourquoi votre MultiKrum n'implémente-t-il pas l'algorithme publié ? »

Le présupposé est qu'il s'agit d'une erreur. Rétablir : l'écart est documenté et
assumé, il porte sur le calcul des scores en une seule passe. Répondre ensuite
sur la conséquence : les garanties de la publication ne se transfèrent pas
automatiquement à cette variante. Voir 3.3 et 3.4.

### « Votre expérience prouve donc que Bulyan est meilleur que Krum ? »

Le présupposé est une généralité que le réglage ne donne pas. Répondre : dans ce
réglage, sous cette attaque, avec une graine, Bulyan est moins dégradé. Cela ne
montre pas une supériorité générale, et 5.4 explique pourquoi.

### « Votre bibliothèque ne fait donc que rassembler des algorithmes déjà publiés ? »

Le présupposé est que l'implémentation n'apporte rien. Répondre : les
algorithmes sont publiés, l'apport est l'interface commune, l'accès sans copie,
les protocoles documentés et les tests. Le catalogue est plus restreint que
celui d'autres outils, ce qui est une limite reconnue. Voir 7.2.

## L'escalade des relances

Une réponse appelle souvent la suivante. Le jury descend rarement plus de trois
crans, et chaque cran a sa question typique.

1. Définition. « Qu'est-ce que MultiKrum ? » Une sélection de $m$ gradients par
   un score de distance, suivie d'une moyenne.
2. Mécanisme. « Pourquoi ce score ? » Un gradient proche de plusieurs autres est
   probablement honnête ; un attaquant coordonné s'écarte du groupe.
3. Portée. « Est-ce garanti ? » Oui sous $n>2f+2$ et $m\leq n-2f-3$ ; le réglage
   de 2017 sort de cette borne.
4. Limite. « Où cela casse-t-il ? » Une perturbation proche du groupe passe la
   sélection ; c'est l'expérience de 2018.

La règle : répondre au cran demandé, puis ouvrir le cran suivant en une phrase.
Répondre au cran 4 à une question de cran 1 donne l'impression de réciter une
défense préparée ; répondre au cran 1 à une question de cran 3 donne
l'impression d'esquiver.

## Cinq règles pour la salle

- Répondre d'abord en une ou deux phrases, puis développer si le jury le demande.
- Distinguer systématiquement une garantie théorique d'une observation sur une
  configuration expérimentale.
- Donner les hypothèses qui changent la conclusion, en particulier $n$, $f$,
  $m$, l'attaque et le partitionnement des données.
- Pour une question sur le code, expliquer d'abord le mécanisme ; ne citer un
  nom de classe Python que si le jury le demande.
- Si la réponse n'est pas connue, dire ce qui est su, ce qui ne l'est pas, et
  comment cela se vérifierait. Une hypothèse non vérifiée présentée comme un
  résultat coûte plus cher qu'un « je ne sais pas » circonscrit.

## Index thématique

| Thème | Questions |
|---|---|
| Modèle de menace et notions | 1.1, 1.2, 1.4, 3.5 |
| Agrégateurs | 2.1, 2.2, 2.4, 3.2, 3.3, 3.4 |
| Attaques | 1.3, 2.3, 2.5 |
| Expériences | 3.1, 5.1, 5.3, 5.4 |
| Méthode et comparaison | 5.2, 5.5, 5.6 |
| Code et bibliothèque | 2.6, 3.7, 7.1, 7.2 |
| Contribution | 6.1, 6.2, 6.3, 6.4 |
| Limites et suite | 4.1, 4.2, 4.3, 4.4, 4.5, 7.3, 7.4 |
| Preuve et portée | 3.6 |
