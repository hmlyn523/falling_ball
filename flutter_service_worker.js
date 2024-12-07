'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js": "d352145460c1dcb8e28a064e9d1bed99",
"splash/img/light-3x.png": "ed5b2566ce8c5ba7c3424c36909dac66",
"splash/img/light-1x.png": "0e11ccf013220e6454618376d6512300",
"splash/img/light-2x.png": "997432f244fa18fc1b3bce575ef0968d",
"splash/img/dark-3x.png": "ed5b2566ce8c5ba7c3424c36909dac66",
"splash/img/dark-1x.png": "0e11ccf013220e6454618376d6512300",
"splash/img/dark-4x.png": "5b38eec5734ce800882796b901781f6d",
"splash/img/light-4x.png": "5b38eec5734ce800882796b901781f6d",
"splash/img/dark-2x.png": "997432f244fa18fc1b3bce575ef0968d",
"splash/style.css": "d4198f3312b6f480da2da5610d5043e5",
"assets/FontManifest.json": "b5208a675ec6c87934b3f6127367848d",
"assets/AssetManifest.bin": "fe2e439bf6b0a2322067ce860e5156f7",
"assets/fonts/MaterialIcons-Regular.otf": "0db35ae7a415370b89e807027510caf0",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/assets/fonts/Square-L.ttf": "6a85340d6fed400674984fbd4d9769ae",
"assets/assets/images/12-icon.png": "46544afdf581d3ed4c807f7db6a441d6",
"assets/assets/images/back_background.png": "3502fa5034d8e9c1bed08fcf467e2134",
"assets/assets/images/empty.png": "65cbc3180b2ea1129110309f25bac1fc",
"assets/assets/images/explosion.png": "63af14a4e1e4048dd57b4495a95c0d14",
"assets/assets/images/copyright.png": "3a65b29289a05316191fd5795817e185",
"assets/assets/images/10-icon.png": "03cf762bbbadb486ca224b182443e838",
"assets/assets/images/11-icon.png": "0851183a01677bf61bda500ee5100dd2",
"assets/assets/images/8-icon.png": "4f75a04cb8ba20835934af4ccb8c6f21",
"assets/assets/images/connect_1.png": "43f8f612b1995c8d10d70836db95ab92",
"assets/assets/images/cancel.png": "21402ab2dedd7e8bf0d75772dbb4dfae",
"assets/assets/images/multi.png": "9cc4780bbc07b6ae2e453cdbf5b3882b",
"assets/assets/images/connect_2.png": "b2cc16df0cafa2b2d2c4f2c341232780",
"assets/assets/images/2-icon.png": "92429b788f0e245197be9cfd2fb07001",
"assets/assets/images/1-icon.png": "fb79910bc50c7c9b863b5cbee7c4182f",
"assets/assets/images/start.png": "cb6c80f340836b35d1af8b59c3150e68",
"assets/assets/images/connect_0.png": "11eb3018d9f1e71c944718965da50047",
"assets/assets/images/menu.png": "2057989bb2f3e0e424b8e9fdabc0bcd2",
"assets/assets/images/post.png": "61b29a978f9ae35d8804ccfd9ab30898",
"assets/assets/images/ranking.png": "dccb336a27a6a0ba73c695a1ba9bbc54",
"assets/assets/images/7-icon.png": "71d15dfd44b7bc1e82871aa56488c100",
"assets/assets/images/back_foreground.png": "7ffbc04906ca3708520de8b6bdf47603",
"assets/assets/images/5-icon.png": "426a6f1dbd34d7f757f86efa09be68df",
"assets/assets/images/title.png": "d417663943b7ad3d542120c6a2b837ed",
"assets/assets/images/4-icon.png": "a40d7a56ec284a4347583a2a72cf2efd",
"assets/assets/images/6-icon.png": "78b2542d01b5ffb466cdeb1c594907e6",
"assets/assets/images/9-icon.png": "9748dc8012d79510115c4b70fa8a2ec8",
"assets/assets/images/game_over.png": "c14a91d2505557e08dc5cc8502c725c5",
"assets/assets/images/3-icon.png": "c7f6d5eae41d0023773f554335222038",
"assets/assets/images/tap_title.png": "90e096e333f8f4a38db23ee25635ea8b",
"assets/assets/audio/sfx/spawn.wav": "68a602aba9e33e519073ada25bdf77c5",
"assets/assets/audio/sfx/collision.wav": "d02ff42cfc310cf42ae8e9798e7e5563",
"assets/assets/audio/bgm.wav": "4565dc5a70e6cec2d00d7780d9d14f68",
"assets/assets/audio/title.wav": "b9dc0b17db6d83bb335b0c6ca627715e",
"assets/NOTICES": "7a61e03515ba511f763187f6ac0574b8",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "51adc2f8e1b56090707e075b858ebfc9",
"assets/AssetManifest.bin.json": "674693d82f2632509ec86ce2e1f18d74",
"index.html": "24ccecaa9f4e374a3fbe98d819233790",
"/": "24ccecaa9f4e374a3fbe98d819233790",
"manifest.json": "5a662627713f86a3c441bec36d415bca",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "1d23ecbef36c5207710608f54dcdfee0",
"flutter_bootstrap.js": "9ed6b6fe56bf7b57c29516cbce302c8c"};
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
