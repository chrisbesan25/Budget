# CLAUDE.md : Budget perso

Fichier lu par Claude Code au début de chaque session sur ce dépôt. Il fait foi contre la mémoire. Établi le 19 octobre 2026 ; à mettre à jour à la fin de chaque chantier (voir « Règle de mise à jour »).

## L'app

- Application de suivi du budget personnel de Christophe : un fichier `index.html` unique (HTML, CSS, JS), publié par GitHub Pages à l'adresse https://chrisbesan25.github.io/Budget/.
- Dépôt de l'app **public** (chrisbesan25/Budget), choix maintenu : GitHub Pages exige un dépôt public sur le plan gratuit.
- Données dans le dépôt **privé** chrisbesan25/budget-data, fichier `budget.json`, lu et écrit par l'API GitHub (point d'accès contents).
- Accès par un code fine-grained limité à budget-data (lecture et écriture du contenu), collé une fois par appareil et rangé dans le navigateur (clé `budget-gh-token`). **Jamais aucun secret ni aucune donnée réelle dans ce dépôt.** Le jeu de départ `DEFAULT_DATA` reste vide.
- Polices Sora et Space Grotesk intégrées au fichier en base64 (24 septembre 2026). La seule ressource extérieure appelée est api.github.com.
- Usage : un PC et un téléphone Android, Chrome, un seul utilisateur.

## Méthode de Christophe (obligatoire)

1. Reformuler la demande avant d'analyser.
2. Diagnostic sur le code réel déployé (vérifier par son empreinte que le fichier lu est celui qui est publié), jamais sur la mémoire. **Aucun code avant sa validation.**
3. Code bloc par bloc, test ciblé après chaque bloc.
4. Banc d'essai complet, puis livraison du fichier.
5. Déploiement et tests réels guidés pas à pas sur ses appareils.

Réponses en français, en le tutoyant, en commençant par « Christophe ». Aucun tiret cadratin (U+2014), demi-cadratin (U+2013) ni signe moins typographique (U+2212), y compris dans le code et ses commentaires. Signaler ce qui n'a pas pu être vérifié.

## Ne pas casser

- **Charte graphique de l'app figée** : fonds colorés pleins et texte blanc gras (Salaire jaune, CM bleu, Revolut orange, Ponctuelles violet...). Aucune couleur ne change sans l'accord de Christophe. Le blanc sur jaune et sur orange est accepté tel quel. La charte des livrables du projet ne s'applique pas à l'app.
- 10 rectangles de synthèse : 5 lignes de 2 sous 700 px, 2 lignes de 5 de 700 à 1 199 px, 1 ligne de 10 à partir de 1 200 px. Ventilation en trois colonnes (Salaire et Ponctuelles, CM, Revolut) à partir de 1 000 px.
- Sélecteur de mois unique, avec l'année. Pointage par occurrence : un mois n'affiche que les cases de son occurrence la plus proche (6 mois en arrière, 5 en avant) ; les rectangles ne dépendent pas des cases.
- Suivi des comptes : Appliquer (montant positif = dépense), dernière opération visible (« 50,00 € »), dépenses en attente CM déduites du solde.
- Totaux mis à jour sans rechargement, arrondi au centime, édition des noms et commentaires au clic, historique IR, noms de banques modifiables (clic sur le nom de la banque).

## Synchronisation (validée en réel les 22, 23 et 24 septembre 2026)

- **État local dans une seule clé**, `budget-etat` : `{ local, baseSha, baseJson, inflight }`, toujours relue puis réécrite en entier (`readState`, `writeState`). Anciennes clés séparées migrées une fois puis supprimées (`migrateState`). Autres clés : `budget-gh-token`, `budget-gh-lastsync`.
- Envoi automatique 3 s après la dernière saisie ; bouton Sauvegarder pour un envoi immédiat ; envoi en une requête keepalive à la mise en arrière-plan.
- Jamais d'écrasement silencieux : décision par comparaison de la version en ligne avec la base ; question à l'utilisateur seulement si les deux côtés ont changé, avec un texte qui dit ce que chaque réponse fait perdre.
- Relecture à l'ouverture, au retour de visibilité, au focus de la fenêtre (regroupés par tranche de 2 s), à la restauration de page, au retour du réseau, et toutes les 30 s tant que la page est visible, en requête conditionnelle (If-None-Match, réponse 304).
- Plusieurs onglets : chaque onglet retient la copie qu'il connaît (`tabLocal`) et la reprend si un autre onglet l'a modifiée, avant toute synchro ; écouteur `storage` filtré sur les clés exactes de Budget.
- Réponse tardive de GitHub rejetée (repère `shaAvant` dans `doSync`).
- Pas de réaffichage pendant une saisie tapée non validée, ni dans les 3 s qui suivent le focus d'un champ (`isEditing`, `FOCUS_GRACE`, `schedulePending`).
- Une limite de débit GitHub (403 avec quota épuisé) ne supprime pas le code d'accès ; un code refusé (401) le supprime, les données restent sur l'appareil.

## Site partagé avec Daily Flow

Daily Flow (dépôt chrisbesan25/daily-flow-v2-claude) est publié sur le même site, chrisbesan25.github.io : **même stockage du navigateur et même espace de cache**. Les clés de Budget commencent par `budget-`, celles de Daily Flow par `daily-flow-v3` (et `df-uid`). Tout nom de cache ou de clé ajouté doit garder ce préfixe, et aucun code de Budget ne doit lire, modifier ou supprimer ce qui appartient à Daily Flow.

## Banc d'essai : règles apprises

- Servir la page sur une vraie adresse `http://localhost` et ouvrir les onglets dans un même contexte de navigateur, sinon le stockage n'est pas partagé.
- Serveur GitHub simulé qui vérifie réellement le sha à chaque envoi (409 en cas d'écart) et gère l'ETag (304).
- Coupure réseau : faire échouer la requête dans la fonction d'interception (le mode hors ligne de Playwright ne bloque pas les requêtes interceptées).
- Onglet gelé : empêcher l'enregistrement de l'écouteur `storage` par un script injecté avant le chargement.
- Réponse tardive : retenir la requête avec une copie du contenu du serveur à cet instant, la libérer plus tard.
- Saisie lettre par lettre, avec l'événement de frappe ; tout sélectionner avant de taper dans un champ rempli.
- Intercepter les fenêtres de confirmation et choisir la réponse explicitement.
- Données fictives uniquement. Un échec peut venir du banc lui-même : l'isoler avant de corriger l'app.

## Déploiement

- Dépôt par « Add file », « Upload files », puis toujours « Commit changes ». Vérifier le nom exact du fichier (pas de « (2) »).
- GitHub Pages publie en quelques minutes ; recharger ensuite chaque appareil.
- Si une version change les clés de stockage : fermer tous les onglets Budget sauf un sur chaque appareil avant de déployer.
- Après tout dépôt fait hors session, ouvrir une nouvelle session Claude Code : une session travaille sur la copie du dépôt prise à son ouverture.

## Ouvert

- **Démarrage hors connexion** (service worker, second fichier `sw.js`) : chantier ouvert le 19 octobre 2026, à traiter avec Daily Flow. Exigences connues : nom de cache préfixé et suppression limitée à ses propres caches ; portée limitée au dossier de l'app ; aucune interception des appels à api.github.com ; page en « réseau d'abord » ; procédure de désactivation ; essai d'une vraie mise à jour, pas seulement du premier chargement.

## Règle de mise à jour

À la fin de chaque chantier, mettre à jour ce fichier : marquer noir sur blanc ce qui est vérifié (banc ou réel, avec la date) et ce qui reste ouvert, et contrôler qu'aucun document plus ancien ne le contredit.
