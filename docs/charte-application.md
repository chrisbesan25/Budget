# Charte de l'application Budget

**Version 1.1 du 22 octobre 2026 · Christophe** (1.0 du même jour : relevé ; 1.1 : décisions de Christophe sur les couples sous les seuils)

> **Ce document décrit, il ne prescrit pas.** Il relève l'allure que l'application applique aujourd'hui, à partir de son code, comme le prévoit la section 7.1 de la charte des livrables (version 1.6.8 du 21 octobre 2026). Il ne change rien à l'application : ni couleur, ni police, ni mise en page.
>
> **Source relevée** : `index.html` de la branche `main`, commit `41e908e`, empreinte SHA-256 `3af370ba6302844a7f2dce4d9b47b758f8f3843c87612496a7b38052f17db45f`. **Non vérifié** : l'identité avec la page servie par GitHub Pages, que la session n'a pas pu télécharger (accès refusé par le mandataire réseau le 22 octobre 2026). GitHub Pages publie `main` ; à contrôler si un dépôt a été fait hors session.
>
> **Copie** : une copie de ce fichier va dans le Contexte du projet Claude « Budget perso ». En cas d'écart, le fichier du dépôt fait foi pour l'allure de l'app.

---

## 1. Statut et portée

La charte des livrables (section 7.1) donne à chaque application sa propre charte. Celle-ci **fixe les couleurs et les polices** de Budget et prévaut, pour ces deux points, sur la charte des livrables. Pour le reste, la charte des livrables s'applique, notamment les seuils de contraste de sa section 1.11.

Les seuils de contraste restent obligatoires, **sauf pour les couples que Christophe a acceptés par écrit et que la section 5.1 énumère**. Un couple nouveau sous le seuil se soumet à Christophe avant d'être employé.

**Décision du 22 octobre 2026.** Le relevé a trouvé, en plus du blanc sur jaune et sur orange, d'autres couples sous les seuils. Christophe les a tous acceptés tels quels le 22 octobre 2026, famille par famille, et a confirmé que l'accord du 22 septembre 2026 couvre les variantes atténuées du jaune et de l'orange. Tous ces couples sont énumérés en section 5.1 ; au 22 octobre 2026, l'app n'emploie aucun couple sous les seuils sans accord écrit.

---

## 2. Polices

Deux polices, intégrées au fichier en base64 depuis le 24 septembre 2026 (aucun appel à Google Fonts) : versions variables, jeu de caractères latin, licence SIL Open Font License 1.1, fichiers issus du projet Fontsource. Police de repli : `sans-serif`.

| Police | Graisses disponibles | Emploi |
|---|---|---|
| **Sora** | 100 à 800 | Police du corps (`body`, 14 px). Boutons du bandeau et de l'accueil, petits boutons de la barre d'état, bouton « + » d'ajout, champs de nom de ligne, de commentaire, d'ajout de ligne et de description Revolut. Tableau de l'historique IR (hérité du corps). |
| **Space Grotesk** | 300 à 700 | Titres et montants : titre « 💰 Budget Perso », montants et champs des 10 rectangles, titre « 📊 Suivi des comptes », noms de banque et soldes du suivi, champs du suivi (solde, nouvelle opération), nom du mois, en-têtes des quatre sections, champs de montant des lignes, montants de la liste d'attente CM, titre de l'historique IR. |
| Police du système (non fixée) | | Éléments où le navigateur ne fait pas hériter la police et où le code n'en fixe pas : boutons ↑ ↓ ×, « Appliquer », « + Ajouter », flèches ‹ › du mois, champ de texte de la liste d'attente CM, champs de la ligne d'ajout de l'historique IR. Fenêtres de confirmation et d'alerte du navigateur. |

**Graisses employées** : 700 (gras) pour les titres, les montants, les libellés et tout texte blanc sur fond coloré ; 600 pour les boutons et les intitulés de champ ; 400 pour le texte courant.

**Tailles** : le corps est à 14 px ; les tailles en `rem` se rapportent à 16 px (la racine n'est pas redéfinie). Exemples : libellé de rectangle 0,65 rem (10,4 px), montant de rectangle 1,2 rem (19,2 px), en-tête de section et nom de ligne 0,85 rem (13,6 px).

**Émojis** dans les titres et les messages (💰 💵 🔵 🟠 🟣 📊 🧾 ☁️ ✅ 💾 🔑 ⚠️ ⏳ 🔄) : dessinés par la police d'émojis de l'appareil.

---

## 3. Couleurs

### 3.1 Jetons (`:root`)

| Jeton | Valeur | Rôle |
|---|---|---|
| `--bg` | `#f0f4f8` | Fond de page, zone du suivi des comptes |
| `--card` | `#ffffff` | Déclaré, non employé par une règle (les cartes écrivent `white`) |
| `--shadow` | `0 4px 20px rgba(0,0,0,0.08)` | Ombre des cartes et des sections |
| `--blue` | `#2563eb` | Crédit Mutuel (CM), bandeau (départ du dégradé), boutons d'action, bordure de champ actif |
| `--blue-dark` | `#1d4ed8` | Survol des boutons bleus |
| `--orange` | `#ea580c` | Revolut, pastille de la barre d'état en alerte |
| `--orange-dark` | `#c2410c` | Déclaré, non employé |
| `--purple` | `#7c3aed` | Ponctuelles, bandeau (arrivée du dégradé) |
| `--purple-dark` | `#6d28d9` | Déclaré, non employé |
| `--green` | `#16a34a` | Reste positif, case pointée, bouton « Appliquer », remboursement IR positif, pastille « synchronisé » |
| `--green-dark` | `#15803d` | Survol du bouton « Appliquer » |
| `--red` | `#dc2626` | Reste négatif, boutons de suppression, remboursement IR négatif |
| `--yellow` | `#eab308` | Salaire (rectangles « Salaire net avant IR » et « Salaire net », section et lignes Salaire) |
| `--cyan` | `#0891b2` | Historique de l'impôt sur le revenu |
| `--pink` | `#db2777` | Rectangle « Impôt (IR) » |
| `--text` | `#1e293b` | Texte courant |
| `--text2` | `#64748b` | Texte secondaire (intitulés de champ, commentaires, détails) |
| `--border` | `#e2e8f0` | Bordures et séparateurs |

### 3.2 Valeurs écrites en dur

| Valeur | Emploi |
|---|---|
| `#64748b` (gris ardoise, même valeur que `--text2`) | Rectangles « Salaire brut » et « Total charges récurrent » |
| `#ffffff` / `white` | Texte sur fonds colorés, cartes, rectangles de synthèse (fond de la zone), bouton « 💾 Sauvegarder » et bouton principal de l'accueil |
| `#e8f5e9`, bordure `#c8e6c9` | Barre d'état : synchronisé, en attente d'envoi |
| `#fff3e0`, bordure `#ffe0b2` | Barre d'état : code d'accès requis, hors connexion, envoi en échec |
| `#e2e8f0`, survol `#cbd5e1` | Bouton « Déconnexion » ; `#cbd5e1` aussi pour le bord des cases non pointées et du champ d'ajout |
| `#f1f5f9` | Boutons ↑ ↓, survol d'un commentaire |
| `#fee2e2` | Boutons × de suppression |
| `#fafafa` | Ligne d'ajout sous chaque section |
| `#f0fdfa` | En-têtes du tableau de l'historique IR |
| `#f8fafc` | Ligne d'ajout de l'historique IR |
| `#eff6ff` | Encadré « Synchronisation GitHub » |
| `#f0abfc`, `#a5f3fc`, `#fef08a`, `#fed7aa`, `#e9d5ff` | Lignes de l'historique IR, en cycle de cinq (rose, cyan, jaune, orange, violet clairs) |
| `rgba(255,255,255, 0.1 à 0.3)` | Voiles blancs : boutons du bandeau et de l'accueil, champs des rectangles et champ de nom en édition |
| `rgba(255,255,255,0.5)` | Indications « 0 » et « % » des champs des rectangles |

Règles présentes dans le code mais **sans effet** (aucun élément ne porte la classe) : `.btn.google` (`#4285f4`, survol `#3367d6`), `.btn.danger`, `.btn-sm.green`, `.section-total`. Vestiges à laisser tels quels tant qu'aucun chantier ne les retire.

### 3.3 Correspondances figées

Fonds colorés pleins et texte blanc gras, sans exception sur les éléments de couleur :

- **Salaire** : jaune `#eab308` ;
- **Crédit Mutuel (CM)** : bleu `#2563eb` ;
- **Revolut** : orange `#ea580c` ;
- **Ponctuelles** : violet `#7c3aed` ;
- **Impôt (IR)** : rose `#db2777` pour le rectangle, cyan `#0891b2` pour l'historique ;
- **Reste/mois et Reste/an** : vert `#16a34a`, rouge `#dc2626` quand le reste est négatif ;
- **Salaire brut et Total charges récurrent** : gris ardoise `#64748b` ;
- **Bandeau et page d'accueil** : dégradé à 135 degrés du bleu `#2563eb` au violet `#7c3aed`.

### 3.4 Formes

Rayons : 12 px pour les rectangles de synthèse, les cartes du suivi et l'historique IR ; 10 px pour les sections et l'encadré de synchronisation ; 6 à 8 px pour les boutons et les champs ; cercle pour les flèches du mois et les cases de pointage. Ombre unique `--shadow`. La disposition (rectangles, colonnes, seuils de largeur) est décrite dans `CLAUDE.md`, section « Ne pas casser ».

---

## 4. Méthode du contrôle de contraste

- Formule de la WCAG (luminance relative), seuils de la section 1.11 de la charte des livrables : **4,5 pour 1** en texte courant, **3 pour 1** en texte large, soit au moins 24 px, ou 18,66 px en gras.
- Est compté comme gras la graisse 700 ; la graisse 600 est comptée comme non grasse (choix prudent).
- Transparences : la couleur du texte ou du voile est composée sur le fond réel avant le calcul.
- Dégradé du bandeau : calcul aux deux extrémités (bleu et violet) ; l'extrémité la plus défavorable est retenue.
- Valeurs arrondies au centième ; aucune valeur affichée ne passe un seuil par l'effet de l'arrondi. Calcul fait le 22 octobre 2026 sur le code, **non vérifié sur rendu réel** (lissage des polices, réglages de l'écran).
- Les états de survol n'existent qu'au PC (souris).

---

## 5. Couples de texte et de fond sous les seuils

### 5.1 Couples acceptés par écrit

Deux accords écrits de Christophe, l'un du 22 septembre 2026, l'autre du 22 octobre 2026.

#### Accord du 22 septembre 2026 : blanc sur jaune et sur orange

**Blanc sur jaune `#eab308` et blanc sur orange `#ea580c` : acceptés par Christophe le 22 septembre 2026** (charte des livrables 1.6.8, section 7.1 ; `CLAUDE.md`, « Ne pas casser »).

| Élément | Texte | Fond | Taille, graisse | Seuil | Contraste |
|---|---|---|---|---|---|
| En-tête de section « 💵 SALAIRE » et son total | blanc | jaune | 13,6 px, gras | 4,5 | 1,92 |
| Nom d'une ligne Salaire, et son champ en édition | blanc | jaune | 13,6 px, gras (12,8 px sous 500 px) | 4,5 | 1,92 |
| Montant du rectangle « Salaire net » | blanc | jaune | 19,2 px, gras (texte large) | 3 | 1,92 |
| En-tête de section Revolut et son total | blanc | orange | 13,6 px, gras | 4,5 | 3,56 |
| Nom d'une ligne Revolut, et son champ en édition | blanc | orange | 13,6 px, gras | 4,5 | 3,56 |
| Nom de banque et solde de la carte Revolut du suivi | blanc | orange | 14,4 px et 17,6 px, gras | 4,5 | 3,56 |

Le montant du rectangle « Charges Revolut » (19,2 px, gras, texte large) atteint 3,56 pour un seuil de 3 : il passe.

**Variantes atténuées des mêmes couples : couvertes par l'accord du 22 septembre 2026**, ce que Christophe a confirmé le 22 octobre 2026.

| Élément | Texte | Fond | Taille, graisse | Seuil | Contraste |
|---|---|---|---|---|---|
| Libellés « Salaire net avant IR », « Salaire net » | blanc à 90 % | jaune | 10,4 px, gras | 4,5 | 1,79 |
| Libellé « Charges Revolut » | blanc à 90 % | orange | 10,4 px, gras | 4,5 | 3,15 |
| Champ « Salaire net avant IR » (voile blanc 20 %) | blanc | `#eec239` | 17,6 px, gras ; 19,2 px sous 500 px (large) ; 16 px dès 1 200 px | 4,5 (3 sous 500 px) | 1,69 |
| Même champ en saisie (voile 30 %) | blanc | `#f0ca52` | idem | idem | 1,58 |
| Indication « 0 » de ce champ (blanc à 50 %) | `#f6e09c` | `#eec239` | idem | idem | 1,29 (1,25 en saisie) |
| Survol d'un nom de ligne Salaire (opacité 90 %, PC) | blanc | `#ecbb21` | 13,6 px, gras | 4,5 | 1,80 |
| Survol d'un nom de ligne Revolut (opacité 90 %, PC) | blanc | `#ec6924` | 13,6 px, gras | 4,5 | 3,18 |

#### Accord du 22 octobre 2026 : autres couples

**Acceptés tels quels par Christophe le 22 octobre 2026**, famille par famille : libellés des rectangles, champs des rectangles, bandeau et accueil, historique de l'impôt, petits boutons, textes secondaires. Avant cette date, aucun accord écrit ne les couvrait.

**Libellés des rectangles de synthèse** (blanc à 90 %, 10,4 px gras ; 11,2 px sous 500 px) :

| Libellé | Texte | Fond | Seuil | Contraste |
|---|---|---|---|---|
| « Salaire brut », « Total charges récurrent » | `#f0f1f3` | gris ardoise `#64748b` | 4,5 | 4,21 |
| « Impôt (IR) » | `#fbe9f1` | rose `#db2777` | 4,5 | 3,95 |
| « Charges CM » (ou nom court de la banque) | `#e9effd` | bleu `#2563eb` | 4,5 | 4,49 |
| « Reste/mois », « Reste/an », reste positif | `#e8f6ed` | vert `#16a34a` | 4,5 | 2,96 |
| « Reste/mois », « Reste/an », reste négatif | `#fce9e9` | rouge `#dc2626` | 4,5 | 4,13 |

**Champs des rectangles** (blanc gras ; 17,6 px de 501 à 1 199 px, seuil 4,5 ; 19,2 px sous 500 px, texte large, seuil 3 ; 16 px dès 1 200 px, seuil 4,5) :

| Champ | Fond (voile composé) | Contraste | Sous le seuil |
|---|---|---|---|
| « Salaire brut », au repos | `#8390a2` | 3,24 | au-dessus de 500 px |
| « Salaire brut », en saisie | `#929eae` | 2,72 | à toutes les largeurs |
| « Impôt (IR) », montant, au repos | `#e25292` | 3,59 | au-dessus de 500 px |
| « Impôt (IR) », montant, en saisie | `#e668a0` | 3,06 | au-dessus de 500 px |
| « Impôt (IR) », champ « % » (14,4 px, 13,6 px dès 1 200 px) | `#e25292`, en saisie `#e668a0` | 3,59 ; 3,06 | à toutes les largeurs |
| Indications « 0 » et « % » (blanc à 50 %), « Salaire brut » | `#8390a2` | 1,92 (1,72 en saisie) | à toutes les largeurs |
| Indications « 0 » et « % » (blanc à 50 %), « Impôt (IR) » | `#e25292` | 1,90 (1,78 en saisie) | à toutes les largeurs |

**Bandeau et accueil** (dégradé bleu vers violet, extrémité bleue la plus défavorable) :

| Élément | Texte | Fond | Taille, graisse | Seuil | Contraste (bleu ; violet) |
|---|---|---|---|---|---|
| Bouton « Local » (voile 15 %) | blanc | `#467aee` ; `#9058f0` | 12,8 px, 600 | 4,5 | 3,98 ; 4,34 |
| Même bouton au survol (voile 25 %, PC) | blanc | `#5c8af0` ; `#9d6bf2` | idem | 4,5 | 3,31 ; 3,61 |
| Boutons « Nouveau budget », « Ouvrir fichier local » (voile 10 %) | blanc | `#3b73ed` ; `#894eef` | 16 px, 600 | 4,5 | 4,32 ; 4,77 |
| Sous-titre « Ton suivi budgétaire mensuel » (blanc à 80 %) | `#d3e0fb` ; `#e5d8fb` | bleu ; violet | 14 px, 400 | 4,5 | 3,89 ; 4,22 |

**Boutons et éléments clairs** :

| Élément | Texte | Fond | Taille, graisse | Seuil | Contraste |
|---|---|---|---|---|---|
| Bouton « Appliquer » | blanc | vert `#16a34a` | 8,8 px, gras | 4,5 | 3,30 |
| Bouton « Déconnexion » | `#64748b` | `#e2e8f0` | 11,2 px, 600 | 4,5 | 3,86 |
| Même bouton au survol (PC) | `#64748b` | `#cbd5e1` | idem | 4,5 | 3,21 |
| Boutons ↑ ↓ | `#64748b` | `#f1f5f9` | 11 px, 400 | 4,5 | 4,34 |
| Boutons × (lignes, liste d'attente, historique IR) | rouge `#dc2626` | `#fee2e2` | 11 px (13,3 px dans la liste d'attente), 400 | 4,5 | 3,95 |
| Survol d'un nom de ligne CM (opacité 90 %, PC) | blanc | `#3b73ed` | 13,6 px, gras | 4,5 | 4,32 |
| Commentaire vide « + commentaire » (gris à 50 %) | `#b2bac5` | blanc | 10,4 px, italique | 4,5 | 1,96 |
| Commentaire au survol (PC) | `#64748b` | `#f1f5f9` | 10,4 px, italique | 4,5 | 4,34 |
| Barre d'état, détail « (budget.json, privé) », synchronisé | `#64748b` | `#e8f5e9` | 12 px | 4,5 | 4,23 |
| Barre d'état, détail, alerte | `#64748b` | `#fff3e0` | 12 px | 4,5 | 4,34 |
| Encadré « Synchronisation GitHub », lignes ✅ | `#64748b` | `#eff6ff` | 12 px | 4,5 | 4,37 |

**Historique de l'impôt sur le revenu** :

| Élément | Texte | Fond | Taille, graisse | Seuil | Contraste |
|---|---|---|---|---|---|
| Titre « 🧾 Historique Impôt sur le Revenu » | blanc | cyan `#0891b2` | 13,6 px, gras | 4,5 | 3,68 |
| En-têtes du tableau (Année, Revenus...) | cyan `#0891b2` | `#f0fdfa` | 11 px, gras | 4,5 | 3,53 |
| Remboursement positif, ligne rose | vert `#16a34a` | `#f0abfc` | 11 px, gras | 4,5 | 1,87 |
| Remboursement positif, ligne cyan | vert | `#a5f3fc` | idem | 4,5 | 2,64 |
| Remboursement positif, ligne jaune | vert | `#fef08a` | idem | 4,5 | 2,83 |
| Remboursement positif, ligne orange | vert | `#fed7aa` | idem | 4,5 | 2,43 |
| Remboursement positif, ligne violette | vert | `#e9d5ff` | idem | 4,5 | 2,42 |
| Remboursement négatif, ligne rose | rouge `#dc2626` | `#f0abfc` | idem | 4,5 | 2,74 |
| Remboursement négatif, ligne cyan | rouge | `#a5f3fc` | idem | 4,5 | 3,87 |
| Remboursement négatif, ligne jaune | rouge | `#fef08a` | idem | 4,5 | 4,15 |
| Remboursement négatif, ligne orange | rouge | `#fed7aa` | idem | 4,5 | 3,57 |
| Remboursement négatif, ligne violette | rouge | `#e9d5ff` | idem | 4,5 | 3,55 |

### 5.2 Couples sous le seuil sans accord écrit

Aucun au 22 octobre 2026. Un couple nouveau sous le seuil se soumet à Christophe avant d'être employé (section 7).

### 5.3 Repères graphiques, hors texte

**Pour information.** La section 1.11 de la charte des livrables ne vise que le texte. Deux repères graphiques sont sous 3 pour 1 face à leur fond : le bord des cases de pointage non cochées (`#cbd5e1` sur blanc, 1,48) et la pastille verte de la barre d'état (`#16a34a` sur `#e8f5e9`, 2,93). La case pointée (vert plein, coche blanche) atteint 3,30.

### 5.4 Couples au-dessus des seuils (principaux)

| Texte | Fond | Contraste | Où |
|---|---|---|---|
| `#1e293b` | blanc, `#f0f4f8`, `#e8f5e9`, `#fff3e0`, `#fafafa` | 13,00 à 14,63 | Texte courant, barre d'état |
| `#1e293b` | lignes de l'historique IR | 8,31 à 12,57 | Cellules du tableau IR |
| blanc | bleu `#2563eb` | 5,17 | Section, lignes et carte CM, boutons bleus, flèches du mois, titre du bandeau (côté bleu) |
| blanc | violet `#7c3aed` | 5,70 | Section et lignes Ponctuelles, titre du bandeau (côté violet) |
| blanc à 90 % | violet | 4,91 | Libellé « Charges ponctuelles » |
| blanc | rose `#db2777` | 4,60 | (aucun texte plein ; voir 5.1 pour le libellé et les champs) |
| blanc | gris ardoise `#64748b` | 4,76 | Montant « Total charges récurrent » |
| blanc | rouge `#dc2626` | 4,83 | Montants du reste négatif, survol des boutons × |
| blanc | vert `#16a34a` | 3,30 | Montants « Reste/mois », « Reste/an » (19,2 px, gras, texte large : seuil 3) |
| bleu `#2563eb` | blanc | 5,17 | Bouton « 💾 Sauvegarder », bouton « 🔑 Connecter mes données » |
| bleu `#2563eb` | `#eff6ff` | 4,75 | Titre de l'encadré de synchronisation |
| `#64748b` | blanc | 4,76 | Intitulés de champ, dernière opération, liste d'attente vide |

---

## 6. Daily Flow

Daily Flow a sa propre charte, à écrire dans son dépôt (chrisbesan25/daily-flow-v2-claude), qui n'est pas accessible depuis cette session. La décision R10 du 21 octobre 2026 (contrastes de l'ambiance ivoire gardés tels quels) relève de cette charte et n'est pas détaillée ici.

---

## 7. Règles d'évolution

1. Aucune couleur ni police de l'app ne change sans l'accord de Christophe.
2. Toute teinte nouvelle est vérifiée au calcul avant emploi, et sa valeur de contraste est notée en commentaire dans le code (charte des livrables, section 1.11).
3. Un couple nouveau sous le seuil se soumet à Christophe avant emploi ; s'il est accepté, il entre en section 5.1 avec la date de l'accord.
4. À chaque changement d'allure, ce fichier est mis à jour (version et date), puis sa copie dans le Contexte du projet Claude.
