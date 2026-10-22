#!/usr/bin/env bash
# Crochet de reprise de session (SessionStart), ajouté le 22 octobre 2026.
# Au démarrage d'une session Claude Code : git fetch, puis alerte si le dépôt en ligne
# a changé depuis la dernière session ou contient des commits absents de la copie de travail.
# Il ne touche jamais aux fichiers de travail ni aux branches locales : il lit seulement.
# Il ne remplace pas la règle de reprise de CLAUDE.md (nouvelle session après tout dépôt hors session).

set -u
cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/../..}" 2>/dev/null || exit 0
git rev-parse --git-dir >/dev/null 2>&1 || exit 0

# Repère de la dernière session, rangé dans .git (jamais versionné, jamais publié).
REPERE="$(git rev-parse --git-dir)/budget-reprise-session"
BRANCHE="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '')"

# Sortie au format attendu par Claude Code : systemMessage pour Christophe,
# additionalContext pour Claude. Encodage JSON par jq.
emettre() {
    jq -n --arg alerte "$1" --arg contexte "$2" '
        (if $alerte != "" then {systemMessage: $alerte} else {} end)
        + {hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $contexte}}'
}

if ! timeout 30 git fetch --quiet origin 2>/dev/null; then
    m="Reprise de session : git fetch a échoué (réseau ou accès). Impossible de vérifier si le dépôt en ligne a changé : le vérifier à la main avant tout travail."
    emettre "$m" "$m"
    exit 0
fi

alertes=""
infos=""
ajouter_alerte() { alertes="${alertes}${alertes:+ ; }$1"; }

# Branches suivies : main (publiée par GitHub Pages) et la branche de travail, si elle existe en ligne.
refs="origin/main"
if [ -n "$BRANCHE" ] && [ "$BRANCHE" != "HEAD" ] && [ "$BRANCHE" != "main" ] \
   && git rev-parse --verify --quiet "refs/remotes/origin/$BRANCHE" >/dev/null; then
    refs="$refs origin/$BRANCHE"
fi

premier=1
[ -f "$REPERE" ] && premier=0
nouveau_repere=""
for ref in $refs; do
    sha="$(git rev-parse --verify --quiet "$ref" 2>/dev/null)" || continue
    court="$(git rev-parse --short "$sha")"
    infos="${infos}${infos:+, }$ref = $court"
    nouveau_repere="${nouveau_repere}${ref} ${sha}
"
    ancien=""
    [ -f "$REPERE" ] && ancien="$(awk -v r="$ref" '$1 == r { print $2 }' "$REPERE")"
    if git merge-base --is-ancestor "$sha" HEAD 2>/dev/null; then
        # Tout ce qui est en ligne est déjà dans la copie de travail (par exemple nos propres envois).
        if [ -n "$ancien" ] && [ "$ancien" != "$sha" ]; then
            infos="${infos} (a avancé depuis la dernière session, commits déjà présents dans la copie)"
        fi
    else
        # Commits en ligne absents de la copie de travail : cas d'un dépôt fait hors session.
        n="$(git rev-list --count "HEAD..$sha" 2>/dev/null || echo '?')"
        if [ -n "$ancien" ] && [ "$ancien" != "$sha" ]; then
            ajouter_alerte "$ref a changé depuis la dernière session ($(git rev-parse --short "$ancien" 2>/dev/null || echo "$ancien") vers $court) et contient $n commit(s) absent(s) de la copie de travail"
        else
            ajouter_alerte "$ref contient $n commit(s) absent(s) de la copie de travail"
        fi
    fi
done

printf '%s' "$nouveau_repere" > "$REPERE" 2>/dev/null

if [ -n "$alertes" ]; then
    m="ALERTE reprise de session : $alertes. Ne rien modifier avant d'avoir relu l'état en ligne ; règle de CLAUDE.md : après un dépôt fait hors session, ouvrir une nouvelle session."
    emettre "$m" "$m (état en ligne : $infos)"
elif [ "$premier" = 1 ]; then
    emettre "" "Reprise de session : premier passage sur cette copie, repère enregistré ; copie de travail à jour ($infos)."
else
    emettre "" "Reprise de session : rien de nouveau en ligne depuis la dernière session, copie de travail à jour ($infos)."
fi
exit 0
