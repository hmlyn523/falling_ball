'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.json": "49b9658654e789d27acfdb10db916b2e",
"assets/assets/images/1-icon.png": "b31c87b9c152270a8d73dab996ce213f",
"assets/assets/images/empty.png": "65cbc3180b2ea1129110309f25bac1fc",
"assets/assets/images/start.png": "4aea27f1f0a7a26740cf22150e27b2da",
"assets/assets/images/7-icon.png": "1d0c6246285d0dd07b1b50c54469d518",
"assets/assets/images/ranking.png": "fb57b7ef59aecb77b0238a36f90d8df8",
"assets/assets/images/3-icon.png": "877c2a696b8b00db805c1a709d9ea3bf",
"assets/assets/images/post.png": "61b29a978f9ae35d8804ccfd9ab30898",
"assets/assets/images/9-icon.png": "8b9dbcadbad5fbe6990be526237a2255",
"assets/assets/images/menu.png": "ac5e4dbaee4b2cda7e80abe4b45f1156",
"assets/assets/images/game_over.png": "c14a91d2505557e08dc5cc8502c725c5",
"assets/assets/images/2-icon.png": "ce64c0c820a5984eac1cfab775fbc5e9",
"assets/assets/images/tap_title.png": "2e7cb77629fc1e6b79f3a34dd1d5496c",
"assets/assets/images/4-icon.png": "a080880d94347a40215426edec83109b",
"assets/assets/images/multi.png": "e40105a028a2b4f67854c545b35257d8",
"assets/assets/images/10-icon.png": "d1502eb6d6c49ec9767d203aa79878fd",
"assets/assets/images/connect_2.png": "b2cc16df0cafa2b2d2c4f2c341232780",
"assets/assets/images/back_foreground.png": "cfe4167ac176e9ea8c9c2d3099d4647d",
"assets/assets/images/8-icon.png": "819a004eef696a18db8055b6719bcb8c",
"assets/assets/images/connect_1.png": "43f8f612b1995c8d10d70836db95ab92",
"assets/assets/images/title.png": "e9843902b0dd7fee9c15d280aab981b2",
"assets/assets/images/6-icon.png": "fcf66eca3928e2efbe9ff9afd06b979e",
"assets/assets/images/cancel.png": "ac190611dae4e046fe218d367e916678",
"assets/assets/images/back_background.png": "af9370e0189b59f9fbffece5215ee700",
"assets/assets/images/copyright.png": "8d3d9f4bd91b391cab500bdb4ffcd624",
"assets/assets/images/5-icon.png": "6c404d33ffd7980b78611513b08d9244",
"assets/assets/images/11-icon.png": "1f4c6f499ee4a94b015f57b53d1ee43a",
"assets/assets/images/connect_0.png": "11eb3018d9f1e71c944718965da50047",
"assets/assets/audio/title.wav": "b9dc0b17db6d83bb335b0c6ca627715e",
"assets/assets/audio/sfx/spawn.wav": "68a602aba9e33e519073ada25bdf77c5",
"assets/assets/audio/sfx/collision.wav": "d02ff42cfc310cf42ae8e9798e7e5563",
"assets/assets/audio/bgm.wav": "4565dc5a70e6cec2d00d7780d9d14f68",
"assets/assets/fonts/Square-L.ttf": "6a85340d6fed400674984fbd4d9769ae",
"assets/AssetManifest.bin.json": "60980a265d7b9a8a96504eaed9d23954",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "0e9fe257d40ddb4046d0de6d67811bb0",
"assets/FontManifest.json": "b5208a675ec6c87934b3f6127367848d",
"assets/NOTICES": "0ff2e3860fd02ae387360acb849b28d9",
"assets/fonts/MaterialIcons-Regular.otf": "0db35ae7a415370b89e807027510caf0",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"canvaskit/canvaskit.js.symbols": "bb7854ddbcaa2e58e5bdef66b58d4b47",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.js": "32cc31c7f950543ad75e035fcaeb2892",
"canvaskit/skwasm.wasm": "aff2178f40209a9841d8d1b47a6e6ec7",
"canvaskit/canvaskit.wasm": "6134e7617dab3bf54500b0a2d94fe17a",
"canvaskit/skwasm.js": "e95d3c5713624a52bf0509ccb24a6124",
"canvaskit/chromium/canvaskit.js.symbols": "f23279209989f44e047062055effde63",
"canvaskit/chromium/canvaskit.js": "6a5bd08897043608cb8858ce71bcdd8a",
"canvaskit/chromium/canvaskit.wasm": "ad6f889daae572b3fd08afc483572ecd",
"canvaskit/skwasm.js.symbols": "dc16cade950cfed532b8c29e0044fe42",
"main.dart.js": "769efd14b2bad2a13206da9839694d40",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"flutter_bootstrap.js": "a4fb59a5d5bbb9861a6ef0e2e1ad23aa",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "5de281a37b2308e43846d3a0b545c921",
"index.html": "24ccecaa9f4e374a3fbe98d819233790",
"/": "24ccecaa9f4e374a3fbe98d819233790",
"version.json": "1d23ecbef36c5207710608f54dcdfee0",
"manifest.json": "5a662627713f86a3c441bec36d415bca",
"splash/style.css": "d4198f3312b6f480da2da5610d5043e5",
"splash/img/light-2x.png": "997432f244fa18fc1b3bce575ef0968d",
"splash/img/dark-4x.png": "5b38eec5734ce800882796b901781f6d",
"splash/img/dark-1x.png": "0e11ccf013220e6454618376d6512300",
"splash/img/light-1x.png": "0e11ccf013220e6454618376d6512300",
"splash/img/dark-2x.png": "997432f244fa18fc1b3bce575ef0968d",
"splash/img/dark-3x.png": "ed5b2566ce8c5ba7c3424c36909dac66",
"splash/img/light-4x.png": "5b38eec5734ce800882796b901781f6d",
"splash/img/light-3x.png": "ed5b2566ce8c5ba7c3424c36909dac66"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
