'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js": "d3d8fdd8e03757356a6b0222632f5fa3",
"index.html": "24ccecaa9f4e374a3fbe98d819233790",
"/": "24ccecaa9f4e374a3fbe98d819233790",
"splash/style.css": "d4198f3312b6f480da2da5610d5043e5",
"splash/img/dark-4x.png": "5b38eec5734ce800882796b901781f6d",
"splash/img/light-1x.png": "0e11ccf013220e6454618376d6512300",
"splash/img/dark-3x.png": "ed5b2566ce8c5ba7c3424c36909dac66",
"splash/img/light-4x.png": "5b38eec5734ce800882796b901781f6d",
"splash/img/light-2x.png": "997432f244fa18fc1b3bce575ef0968d",
"splash/img/dark-1x.png": "0e11ccf013220e6454618376d6512300",
"splash/img/light-3x.png": "ed5b2566ce8c5ba7c3424c36909dac66",
"splash/img/dark-2x.png": "997432f244fa18fc1b3bce575ef0968d",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"manifest.json": "5a662627713f86a3c441bec36d415bca",
"version.json": "1d23ecbef36c5207710608f54dcdfee0",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"assets/fonts/MaterialIcons-Regular.otf": "0db35ae7a415370b89e807027510caf0",
"assets/NOTICES": "6421beb22c44c62f6d43b3bbf97c6ad2",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/assets/fonts/Square-L.ttf": "6a85340d6fed400674984fbd4d9769ae",
"assets/assets/images/3-icon.png": "45f43fb81cf580ceadf7c3053caaad51",
"assets/assets/images/tap_title.png": "1aeaadc8c2940a5451e3647d0f355e94",
"assets/assets/images/connect_0.png": "b570409c397ae7daf24b2fc0a5614a43",
"assets/assets/images/ranking.png": "63829d64c5836aab9c2cc5d587bb2815",
"assets/assets/images/10-icon.png": "2ea752f121c4083482fbec540a2f0289",
"assets/assets/images/game_over.png": "a9192cb8e734651708b46633e11a0dc3",
"assets/assets/images/connect_1.png": "eeaccc92c8fb6a48388ceb0249839c4f",
"assets/assets/images/9-icon.png": "3a48ae81b9b7a17950c6680d39e65dc2",
"assets/assets/images/4-icon.png": "98a4961dac03c9215a0b6bad9ad43454",
"assets/assets/images/empty.png": "65cbc3180b2ea1129110309f25bac1fc",
"assets/assets/images/11-icon.png": "421453ec037ba86b464be64ada0043e3",
"assets/assets/images/post.png": "61b29a978f9ae35d8804ccfd9ab30898",
"assets/assets/images/back_background.png": "0e77a767eecc7daed759fbc50868714c",
"assets/assets/images/copyright.png": "5e49425d50d3d593022293aa1178ce77",
"assets/assets/images/menu.png": "95120d385687f8c02ff1b684fcea7878",
"assets/assets/images/cancel.png": "05b216f943275ee5363c93a329d60a12",
"assets/assets/images/8-icon.png": "e17282d4cc3a36069a798c0887220702",
"assets/assets/images/6-icon.png": "1cb6bbd16a73868136fe756397354afa",
"assets/assets/images/1-icon.png": "879eb2265b9b7ea9f8ee93a1ba397001",
"assets/assets/images/5-icon.png": "752a5ab557f36838f530143bc12e165c",
"assets/assets/images/title.png": "fa6255acd0916a68bd52d069ac55cfbe",
"assets/assets/images/multi.png": "32430bf2b0a4a5c9c9ce59ed1d0303ea",
"assets/assets/images/2-icon.png": "afaf21d2783671b7c6e319e919d37467",
"assets/assets/images/7-icon.png": "1529b3474092609ebaf19973063dd7b0",
"assets/assets/images/connect_2.png": "e63488363ca935dd27c6f4c1fab45e45",
"assets/assets/images/start.png": "c4392140a59cb9ad11565d8a39e8a00e",
"assets/assets/audio/title.wav": "b9dc0b17db6d83bb335b0c6ca627715e",
"assets/assets/audio/bgm.wav": "4565dc5a70e6cec2d00d7780d9d14f68",
"assets/assets/audio/sfx/collision.wav": "d02ff42cfc310cf42ae8e9798e7e5563",
"assets/assets/audio/sfx/spawn.wav": "68a602aba9e33e519073ada25bdf77c5",
"assets/AssetManifest.json": "2b3152e21ddebfddb371df043092579f",
"assets/FontManifest.json": "b5208a675ec6c87934b3f6127367848d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/AssetManifest.bin.json": "840862a3a4736ad31872528b5fdf67f7",
"assets/AssetManifest.bin": "996b3a03c318650063eea29487613fed",
"flutter_bootstrap.js": "1a6cc22a25aab7b5cebfee7f90e6a139",
"canvaskit/skwasm.js": "e95d3c5713624a52bf0509ccb24a6124",
"canvaskit/chromium/canvaskit.wasm": "ad6f889daae572b3fd08afc483572ecd",
"canvaskit/chromium/canvaskit.js": "6a5bd08897043608cb8858ce71bcdd8a",
"canvaskit/chromium/canvaskit.js.symbols": "f23279209989f44e047062055effde63",
"canvaskit/canvaskit.wasm": "6134e7617dab3bf54500b0a2d94fe17a",
"canvaskit/skwasm.js.symbols": "dc16cade950cfed532b8c29e0044fe42",
"canvaskit/skwasm.wasm": "aff2178f40209a9841d8d1b47a6e6ec7",
"canvaskit/canvaskit.js": "32cc31c7f950543ad75e035fcaeb2892",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.js.symbols": "bb7854ddbcaa2e58e5bdef66b58d4b47",
"flutter.js": "5de281a37b2308e43846d3a0b545c921"};
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
