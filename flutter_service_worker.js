'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"splash/img/dark-2x.png": "997432f244fa18fc1b3bce575ef0968d",
"splash/img/light-4x.png": "5b38eec5734ce800882796b901781f6d",
"splash/img/light-3x.png": "ed5b2566ce8c5ba7c3424c36909dac66",
"splash/img/dark-3x.png": "ed5b2566ce8c5ba7c3424c36909dac66",
"splash/img/light-1x.png": "0e11ccf013220e6454618376d6512300",
"splash/img/dark-4x.png": "5b38eec5734ce800882796b901781f6d",
"splash/img/dark-1x.png": "0e11ccf013220e6454618376d6512300",
"splash/img/light-2x.png": "997432f244fa18fc1b3bce575ef0968d",
"splash/style.css": "d4198f3312b6f480da2da5610d5043e5",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"version.json": "2009e33ee92575714318bb93c345bb23",
"flutter_bootstrap.js": "3d941ad78d71efb28a3b0eee2395b8b6",
"manifest.json": "5a662627713f86a3c441bec36d415bca",
"main.dart.js": "5f9ba21709296edc1af558fe593e85dd",
"index.html": "ed5e2541ccfb08bd343f4c4d6319504d",
"/": "ed5e2541ccfb08bd343f4c4d6319504d",
"assets/AssetManifest.json": "8aac97717624ca93f9e4db59e40d9404",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "0db35ae7a415370b89e807027510caf0",
"assets/AssetManifest.bin": "3a066a800d011e070b9d5c50aab829e1",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/FontManifest.json": "949199ba5748a451cccb39ef2807c67a",
"assets/AssetManifest.bin.json": "d6944f59fdf0b36fb9b937046b6aace7",
"assets/NOTICES": "774655ec431a0494c8fd1d690a157e48",
"assets/assets/audio/title.wav": "b9dc0b17db6d83bb335b0c6ca627715e",
"assets/assets/audio/bgm.mp3": "2720a15eb3340ca843d0c0a70f557e40",
"assets/assets/audio/sfx/collision.wav": "d02ff42cfc310cf42ae8e9798e7e5563",
"assets/assets/audio/sfx/spawn.wav": "68a602aba9e33e519073ada25bdf77c5",
"assets/assets/audio/bgm.wav": "4565dc5a70e6cec2d00d7780d9d14f68",
"assets/assets/images/cancel.png": "68535aadd489c6f7184155e7f37adf2c",
"assets/assets/images/lose.png": "5b2b3155eaa68f2d91834a49b372fafd",
"assets/assets/images/post.png": "61b29a978f9ae35d8804ccfd9ab30898",
"assets/assets/images/enemy_ball_height.png": "db07c6fb3b8d3c255640c1d2d2a25b5b",
"assets/assets/images/back_foreground.png": "2dfc3a5c93945d706e29764b458f10ff",
"assets/assets/images/enemy_ball_height2.png": "740ca24bb8a7ef350f853b3bde0c6cda",
"assets/assets/images/connect_1.png": "1d9db14e36204a0b7a9a624ebc7ea3cd",
"assets/assets/images/copyright.png": "b3f9d96d2709388e21d4d14cdcb7e9f1",
"assets/assets/images/11-icon.png": "5492527672ec5b8d08ef43120a8a158e",
"assets/assets/images/5-icon.png": "c0deab0d66516f4edc54bf5495c0855d",
"assets/assets/images/game_over.png": "42340ab70273c686114e760eb1117c4e",
"assets/assets/images/title.png": "61b7199eb29c28fc2de084d93db8f849",
"assets/assets/images/back_background.png": "728a194040e8c840663b38fdc768c2a7",
"assets/assets/images/9-icon.png": "2e0eb44ffc3bc4f05fc0be188ef16403",
"assets/assets/images/win.png": "5353a81940ec799d6c27c3eab02d95be",
"assets/assets/images/1-icon.png": "a74eefbae3ed3828196efc67e98cec24",
"assets/assets/images/tap_title.png": "ea8d178ffee813c471763936f012afb9",
"assets/assets/images/multi2.png": "8d5f965a12819eae12bb8756beccec12",
"assets/assets/images/4-icon.png": "53b18b4f42c010ddddfd965319a35c99",
"assets/assets/images/6-icon.png": "4a01923c11532c88bc5ccfb4f68b51a0",
"assets/assets/images/2-icon.png": "f929ce3a94d92be3f7d1dc8ba203aaf5",
"assets/assets/images/connect_2.png": "c6785721173379966852b1f2067a0576",
"assets/assets/images/start.png": "90f875207dd55519134e6d227e2c45e2",
"assets/assets/images/7-icon.png": "7f0194fe8a0e9c26ea69d91f28d6c586",
"assets/assets/images/explosion.png": "63af14a4e1e4048dd57b4495a95c0d14",
"assets/assets/images/multi3.png": "313b43de133702919c2c6a4f59ee9407",
"assets/assets/images/connect_3.png": "87cc59edadb6054c3be194ea929a143d",
"assets/assets/images/ranking_dialog.png": "13fe0c6fcd1b4d6f1d8cd21a94a49b44",
"assets/assets/images/score.png": "d1627288c9d9eb68833fc49d2177862b",
"assets/assets/images/empty.png": "65cbc3180b2ea1129110309f25bac1fc",
"assets/assets/images/menu.png": "751bddafea4540a7ff52a1827c76cd61",
"assets/assets/images/connect_4.png": "93d4d474badb8ed3c8364f01c2bd774d",
"assets/assets/images/3-icon.png": "dbdb407f214328f43d17b2faf0677762",
"assets/assets/images/8-icon.png": "4a4dd84557eeb98e5f4f543361f27147",
"assets/assets/images/12-icon.png": "a49089521b78d3524d17ea275b8282d7",
"assets/assets/images/ranking.png": "3a3e89d2156fb08beb489d329c8ed427",
"assets/assets/images/10-icon.png": "c4531bb23e3312b477ddba1dfb71c72b",
"assets/assets/images/connect_0.png": "89b86c6c1ceb1c36b0ccd213fcdf659d",
"assets/assets/fonts/PressStart2P-Regular.ttf": "f98cd910425bf727bd54ce767a9b6884",
"assets/assets/fonts/Square-L.ttf": "6a85340d6fed400674984fbd4d9769ae",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796"};
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
