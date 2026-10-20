// Service worker de Budget perso : démarrage hors connexion (20/10/2026).
// Portée : le seul dossier de l'app (/Budget/). Seule la page est gardée en cache.
// Aucune autre requête n'est interceptée : les appels à api.github.com (synchro) passent
// directement par le navigateur, comme sans service worker.
// Site partagé avec Daily Flow : ce fichier ne crée et ne supprime que des caches « budget-sw-* ».
// Mise à jour : changer VERSION ; l'activation efface alors les anciens caches de Budget seulement.

const VERSION = 'v2';
const PREFIXE = 'budget-sw-';
const CACHE = PREFIXE + VERSION;
const PORTEE = self.registration.scope;              // https://chrisbesan25.github.io/Budget/
const PAGE = PORTEE;                                  // clé unique de la page dans le cache
const CHEMINS_PAGE = [new URL(PORTEE).pathname, new URL(PORTEE).pathname + 'index.html'];
const DELAI_RESEAU = 4000;                            // au-delà, la dernière copie enregistrée est servie

// Installation : la page est enregistrée tout de suite (en cas d'échec, le navigateur réessaiera)
self.addEventListener('install', e => {
    e.waitUntil((async () => {
        const res = await fetch(PAGE, { cache: 'no-cache' });
        if (!res.ok) throw new Error('page : ' + res.status);
        await (await caches.open(CACHE)).put(PAGE, res);
        await self.skipWaiting();
    })());
});

// Activation : suppression des anciennes versions de NOS caches, jamais de ceux de Daily Flow
self.addEventListener('activate', e => {
    e.waitUntil((async () => {
        for (const k of await caches.keys()) {
            if (k.startsWith(PREFIXE) && k !== CACHE) await caches.delete(k);
        }
        await self.clients.claim();
    })());
});

self.addEventListener('fetch', e => {
    const req = e.request;
    if (req.method !== 'GET' || req.mode !== 'navigate') return;
    const url = new URL(req.url);
    if (url.origin !== location.origin || !CHEMINS_PAGE.includes(url.pathname)) return;
    e.respondWith(pageReseauDabord(e));
});

// Page en « réseau d'abord » : la version en ligne (revalidée auprès de GitHub Pages), sinon,
// sans réseau ou après DELAI_RESEAU, la dernière copie enregistrée. Une réponse arrivée en retard
// met quand même la copie à jour pour la prochaine ouverture.
async function pageReseauDabord(e) {
    const cache = await caches.open(CACHE);
    const enLigne = fetch(PAGE, { cache: 'no-cache' }).then(async res => {
        if (!res.ok || res.redirected) return null;
        await cache.put(PAGE, res.clone()).catch(() => {});      // stockage plein : la page est servie quand même
        return res;
    }).catch(() => null);
    e.waitUntil(enLigne);
    const copie = await cache.match(PAGE);
    if (!copie) return (await enLigne) || fetch(e.request);    // pas de copie : comportement normal
    const delai = new Promise(r => setTimeout(() => r(null), DELAI_RESEAU));
    return (await Promise.race([enLigne, delai])) || copie;
}
