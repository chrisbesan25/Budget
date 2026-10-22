# CLAUDE.md : Budget perso

Fichier lu par Claude Code au début de chaque session sur ce dépôt. Il fait foi contre la mémoire. Établi le 19 octobre 2026, mis à jour le 20 octobre 2026 (démarrage hors connexion) et le 22 octobre 2026 (charte de l'app, crochet de reprise de session) ; à mettre à jour à la fin de chaque chantier (voir « Règle de mise à jour »).

## L'app

- Application de suivi du budget personnel de Christophe : un fichier `index.html` (HTML, CSS, JS), publié par GitHub Pages à l'adresse https://chrisbesan25.github.io/Budget/ (toujours avec la barre finale).
- Seule exception à la règle du fichier unique (20 octobre 2026) : `sw.js`, le service worker du démarrage hors connexion. `docs/sw-arret.js` est sa version d'arrêt de secours. `docs/fiche-pont-hors-connexion.md` résume le chantier pour les deux apps. `docs/charte-application.md` décrit l'allure de l'app (polices, couleurs, contrastes).
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

- **Charte graphique de l'app figée** : fonds colorés pleins et texte blanc gras (Salaire jaune, CM bleu, Revolut orange, Ponctuelles violet...). Aucune couleur ne change sans l'accord de Christophe. Le blanc sur jaune et sur orange est accepté tel quel. La charte de l'app (docs/charte-application.md, copie dans le Contexte du projet Claude) fixe son allure ; la charte des livrables (section 7.1) s'applique pour le reste, et tout nouveau couple de couleurs sous les seuils de contraste se soumet à Christophe avant emploi.
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

Daily Flow (dépôt chrisbesan25/daily-flow-v2-claude) est publié sur le même site, chrisbesan25.github.io : **même stockage du navigateur et même espace de cache**. Les clés de Budget commencent par `budget-`, celles de Daily Flow par `daily-flow-v3` (et `df-uid`). Caches du service worker : `budget-sw-*` pour Budget, `daily-flow-v3-sw-*` pour Daily Flow (20 octobre 2026). Tout nom de cache ou de clé ajouté doit garder ce préfixe, et aucun code de Budget ne doit lire, modifier ou supprimer ce qui appartient à Daily Flow.

## Démarrage hors connexion (vérifié au banc et en réel le 20 octobre 2026)

- `sw.js`, portée `/Budget/` seulement. Il ne garde que la page, dans le cache `budget-sw-<VERSION>`, et ne supprime que les caches `budget-sw-*`. Aucune autre requête n'est interceptée : les appels à api.github.com (lecture, envoi, keepalive) passent par le navigateur comme avant.
- Page en « réseau d'abord » : version en ligne revalidée (`cache: 'no-cache'`), sinon, sans réseau ou au-delà de 4 s, la dernière copie enregistrée ; une réponse arrivée en retard met la copie à jour pour l'ouverture suivante. Activation immédiate (`skipWaiting`, `clients.claim`).
- Enregistrement dans `index.html` à l'événement `load`, constante `SW_ACTIF`.
- Vérifié en réel le 20 octobre 2026 sur le PC et le téléphone Android : cache présent, ouverture sans réseau avec les données, saisie hors ligne gardée puis envoyée au retour du réseau, deux inscriptions distinctes (Budget et Daily Flow) dans `chrome://serviceworker-internals`.
- Mise à jour réelle vérifiée le 20 octobre 2026 sur le PC et le téléphone : passage de `VERSION` à `v2`, cache `budget-sw-v2` à la place de `budget-sw-v1`, ouverture sans réseau avec les données, cache de Daily Flow intact.
- Limites connues :
  - premier lancement sans réseau non couvert : l'app doit avoir été ouverte une fois en ligne après chaque installation ;
  - une adresse sans barre finale (`/Budget`) ne s'ouvre pas hors ligne (redirection hors de la portée) : favoris et icônes doivent finir par `/Budget/` (vérifié le 20 octobre 2026) ;
  - après un déploiement, une ouverture hors ligne ou sur réseau lent sert l'ancienne page, sans signe visible, jusqu'à la prochaine ouverture en ligne rapide.
- Refus 409 de GitHub avec deux onglets au retour du réseau : rattrapé sans perte ni question, comportement identique sans service worker (banc du 20 octobre 2026). Hors périmètre.

### Désactivation (dans l'ordre de préférence)

1. Mettre `SW_ACTIF = false` dans `index.html` et déposer : à la prochaine ouverture en ligne, la page retire son service worker et ses caches `budget-sw-*`, sans toucher à Daily Flow.
2. Secours : remplacer le contenu de `sw.js` par celui de `docs/sw-arret.js` et déposer (à combiner avec 1 pour un arrêt complet).
3. Sur un seul appareil, sans dépôt :
   - PC : F12, Appli, Service workers, « Unregister » sur la portée `/Budget/`, puis Espace de stockage du cache : supprimer seulement `budget-sw-*`.
   - Android : `chrome://serviceworker-internals` (page disponible, vérifié le 20 octobre 2026), « Unregister » sur la ligne dont la portée est `/Budget/` seulement.
- **Ne jamais utiliser « Effacer les données du site » ni « Effacer et réinitialiser » pour désactiver le service worker** (utiliser les trois moyens ci-dessus) : cela efface aussi la copie locale non envoyée, le code d'accès et toutes les données de Daily Flow.
- Nettoyage complet du navigateur (habitude de Christophe, cookies compris) : possible. Avant, vérifier que tout est envoyé dans les deux apps ; après, rouvrir chaque app une fois en ligne et ressaisir les codes, ce qui remet en place le démarrage hors connexion. L'exception « toujours autoriser les cookies » de Chrome ne protège pas d'un nettoyage manuel (règle convenue le 20 octobre 2026).

## Banc d'essai : règles apprises

- Servir la page sur une vraie adresse `http://localhost` et ouvrir les onglets dans un même contexte de navigateur, sinon le stockage n'est pas partagé.
- Serveur GitHub simulé qui vérifie réellement le sha à chaque envoi (409 en cas d'écart) et gère l'ETag (304).
- Coupure réseau : faire échouer la requête dans la fonction d'interception (le mode hors ligne de Playwright ne bloque pas les requêtes interceptées).
- Onglet gelé : empêcher l'enregistrement de l'écouteur `storage` par un script injecté avant le chargement.
- Réponse tardive : retenir la requête avec une copie du contenu du serveur à cet instant, la libérer plus tard.
- Saisie lettre par lettre, avec l'événement de frappe ; tout sélectionner avant de taper dans un champ rempli.
- Intercepter les fenêtres de confirmation et choisir la réponse explicitement.
- Données fictives uniquement. Un échec peut venir du banc lui-même : l'isoler avant de corriger l'app.
- Service worker : lancer Playwright avec `PW_EXPERIMENTAL_SERVICE_WORKER_NETWORK_EVENTS=1`, sinon les requêtes émises par le service worker échappent aux interceptions et partent sur le vrai réseau.
- Pour une coupure réseau visible du service worker, faire tomber la connexion côté serveur local (socket fermée), en plus de `setOffline`.
- Interception active = cache HTTP désactivé par Playwright : le cache HTTP (max-age=600 de GitHub Pages, redirection 301) n'est jamais testé au banc, seulement en réel.
- Tester une vraie mise à jour : servir plusieurs versions (page et `sw.js` modifiés, version avec `SW_ACTIF = false`, version d'arrêt) et basculer de l'une à l'autre.

## Déploiement

- Dépôt par « Add file », « Upload files », puis toujours « Commit changes ». Vérifier le nom exact du fichier (pas de « (2) »).
- GitHub Pages publie en quelques minutes ; recharger ensuite chaque appareil.
- Si une version change les clés de stockage : fermer tous les onglets Budget sauf un sur chaque appareil avant de déployer.
- Après tout dépôt fait hors session, ouvrir une nouvelle session Claude Code : une session travaille sur la copie du dépôt prise à son ouverture.
- Crochet de reprise de session (22 octobre 2026) : `.claude/settings.json` lance `.claude/hooks/reprise-session.sh` au démarrage de chaque session. Il fait `git fetch`, puis alerte si `main` ou la branche de travail en ligne a changé depuis la dernière session ou contient des commits absents de la copie de travail ; il ne modifie rien. Repère gardé dans `.git/budget-reprise-session` (perdu avec le conteneur : dans une copie neuve, seule la comparaison avec la copie de travail joue). Il complète la règle précédente, qui reste.
- Service worker (depuis le 20 octobre 2026) :
  - une modification de `sw.js` change toujours `VERSION` ; une modification de la seule page n'en a pas besoin ;
  - après un dépôt, ouvrir l'app **en ligne, avec un bon réseau**, sur chaque appareil, et vérifier que la nouvelle version est affichée avant toute saisie ;
  - une version qui change les clés ou le format des données doit savoir lire l'ancien format : une ancienne page peut encore tourner hors ligne ;
  - avant de supprimer, de renommer le dépôt ou de le passer en privé (ce qui arrête GitHub Pages sur le plan gratuit) : désactiver d'abord (voir « Désactivation ») et ouvrir l'app en ligne sur chaque appareil, sinon l'ancienne copie reste servie sans fin.

## Ouvert

- Rien d'ouvert sur le démarrage hors connexion (chantier clos le 20 octobre 2026).
- Charte de l'app (22 octobre 2026) : couples de couleurs sous les seuils sans accord écrit, listés en section 5.2 de `docs/charte-application.md`, à soumettre à Christophe couple par couple ; variantes atténuées du blanc sur jaune et sur orange (section 5.1) : couverture par l'accord du 22 septembre 2026 à confirmer. Crochet de reprise de session vérifié au banc le 22 octobre 2026, pas encore en réel au démarrage d'une session.
- Hors périmètre, noté : refus 409 de GitHub avec deux onglets au retour du réseau, rattrapé sans perte (voir « Démarrage hors connexion »).

## Règle de mise à jour

À la fin de chaque chantier, mettre à jour ce fichier : marquer noir sur blanc ce qui est vérifié (banc ou réel, avec la date) et ce qui reste ouvert, et contrôler qu'aucun document plus ancien ne le contredit.
