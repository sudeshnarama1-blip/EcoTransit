/*
 * EcoTransit service worker.
 *
 * Pages (JSP) are always fetched fresh from the server, because they show
 * per-user data (bookings, impact, profile). They are never cached.
 * Static files (CSS, icons) are cached so the app opens fast.
 * If the phone is offline, the user sees offline.html instead of an error.
 *
 * Bump CACHE_VERSION whenever you change style.css or the icons.
 */
const CACHE_VERSION = "ecotransit-v1";

const STATIC_FILES = [
  "css/style.css",
  "offline.html",
  "manifest.json",
  "icons/icon-192.png",
  "icons/icon-512.png",
  "icons/apple-touch-icon.png"
];

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_VERSION).then((cache) => cache.addAll(STATIC_FILES))
  );
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_VERSION).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener("fetch", (event) => {
  const request = event.request;

  // Only handle same-origin GET requests; form POSTs go straight to the server.
  if (request.method !== "GET" || new URL(request.url).origin !== self.location.origin) {
    return;
  }

  // Page navigations: network only, with an offline fallback.
  if (request.mode === "navigate") {
    event.respondWith(
      fetch(request).catch(() => caches.match("offline.html"))
    );
    return;
  }

  // Static files: serve from cache, refresh it in the background.
  event.respondWith(
    caches.match(request).then((cached) => {
      const network = fetch(request)
        .then((response) => {
          if (response.ok && STATIC_FILES.some((f) => request.url.endsWith(f))) {
            const copy = response.clone();
            caches.open(CACHE_VERSION).then((cache) => cache.put(request, copy));
          }
          return response;
        })
        .catch(() => cached);
      return cached || network;
    })
  );
});
