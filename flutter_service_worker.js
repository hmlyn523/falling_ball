'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-512.png": "390a61a05d8e5e5c83f2b00a8a4738e9",
"icons/Icon-192.png": "28be48d815b518228568719e89fa087b",
"flutter_bootstrap.js": "10a54e3c72c158c9808bfc1566913b33",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"main.dart.js": "6763e8f3d73622762266c363665710c2",
"version.json": "2009e33ee92575714318bb93c345bb23",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/FontManifest.json": "949199ba5748a451cccb39ef2807c67a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "8aac97717624ca93f9e4db59e40d9404",
"assets/assets/images/back_foreground.png": "2dfc3a5c93945d706e29764b458f10ff",
"assets/assets/images/back_background.png": "6ece1e21b75f1266e241793bcd93dc81",
"assets/assets/images/3-icon.png": "4297f545a044c02e89b0bd900839761a",
"assets/assets/images/win.png": "4c4297e9cd5e4a4ec31dbd29a91087bd",
"assets/assets/images/enemy_ball_height2.png": "740ca24bb8a7ef350f853b3bde0c6cda",
"assets/assets/images/game_over.png": "42340ab70273c686114e760eb1117c4e",
"assets/assets/images/title.png": "b3548283aa3aff123cf1f509dc10ba67",
"assets/assets/images/10-icon.png": "880426ec732173d9370b4fa4e93ebade",
"assets/assets/images/connect_4.png": "93d4d474badb8ed3c8364f01c2bd774d",
"assets/assets/images/explosion.png": "63af14a4e1e4048dd57b4495a95c0d14",
"assets/assets/images/8-icon.png": "421e10bd0a1cdeb7df5cf95a5ad9bb85",
"assets/assets/images/empty.png": "65cbc3180b2ea1129110309f25bac1fc",
"assets/assets/images/connect_3.png": "87cc59edadb6054c3be194ea929a143d",
"assets/assets/images/6-icon.png": "a3aaeb98d8f2b366e5e2e78445c57596",
"assets/assets/images/2-icon.png": "5d22d3a35c6c2b7f89b5304bf3275fb8",
"assets/assets/images/menu.png": "751bddafea4540a7ff52a1827c76cd61",
"assets/assets/images/11-icon.png": "3cc79128039dad87e6f30aaa339bbb39",
"assets/assets/images/1-icon.png": "cac108fa0a8875758cde3ee383dd76e1",
"assets/assets/images/5-icon.png": "7139b9c5ecca35847595ed23e5409a66",
"assets/assets/images/connect_1.png": "1d9db14e36204a0b7a9a624ebc7ea3cd",
"assets/assets/images/copyright.png": "b3f9d96d2709388e21d4d14cdcb7e9f1",
"assets/assets/images/4-icon.png": "9406fdb8f85c344602b625dfe9c0a30c",
"assets/assets/images/ranking_dialog.png": "13fe0c6fcd1b4d6f1d8cd21a94a49b44",
"assets/assets/images/12-icon.png": "491289f3aa381f59198b9b004f490f6e",
"assets/assets/images/ranking.png": "3a3e89d2156fb08beb489d329c8ed427",
"assets/assets/images/tap_title.png": "ea8d178ffee813c471763936f012afb9",
"assets/assets/images/multi3.png": "313b43de133702919c2c6a4f59ee9407",
"assets/assets/images/9-icon.png": "1d983e869ba0045c12883158bfe32241",
"assets/assets/images/7-icon.png": "6bdb618bb75dba6664bca5761347612b",
"assets/assets/images/post.png": "61b29a978f9ae35d8804ccfd9ab30898",
"assets/assets/images/connect_2.png": "c6785721173379966852b1f2067a0576",
"assets/assets/images/connect_0.png": "89b86c6c1ceb1c36b0ccd213fcdf659d",
"assets/assets/images/cancel.png": "68535aadd489c6f7184155e7f37adf2c",
"assets/assets/images/start.png": "90f875207dd55519134e6d227e2c45e2",
"assets/assets/images/score.png": "d1627288c9d9eb68833fc49d2177862b",
"assets/assets/images/lose.png": "85970e2b801ce9f35c87dac18d504116",
"assets/assets/images/enemy_ball_height.png": "db07c6fb3b8d3c255640c1d2d2a25b5b",
"assets/assets/images/multi2.png": "8d5f965a12819eae12bb8756beccec12",
"assets/assets/fonts/PressStart2P-Regular.ttf": "f98cd910425bf727bd54ce767a9b6884",
"assets/assets/fonts/Square-L.ttf": "6a85340d6fed400674984fbd4d9769ae",
"assets/assets/audio/bgm.wav": "4565dc5a70e6cec2d00d7780d9d14f68",
"assets/assets/audio/sfx/spawn.wav": "68a602aba9e33e519073ada25bdf77c5",
"assets/assets/audio/sfx/collision.wav": "d02ff42cfc310cf42ae8e9798e7e5563",
"assets/assets/audio/title.wav": "b9dc0b17db6d83bb335b0c6ca627715e",
"assets/assets/audio/bgm.mp3": "2720a15eb3340ca843d0c0a70f557e40",
"assets/NOTICES": "774655ec431a0494c8fd1d690a157e48",
"assets/AssetManifest.bin": "3a066a800d011e070b9d5c50aab829e1",
"assets/fonts/MaterialIcons-Regular.otf": "0db35ae7a415370b89e807027510caf0",
"assets/AssetManifest.bin.json": "d6944f59fdf0b36fb9b937046b6aace7",
"splash/style.css": "d4198f3312b6f480da2da5610d5043e5",
"splash/img/dark-3x.png": "ed5b2566ce8c5ba7c3424c36909dac66",
"splash/img/light-4x.png": "5b38eec5734ce800882796b901781f6d",
"splash/img/dark-2x.png": "997432f244fa18fc1b3bce575ef0968d",
"splash/img/light-3x.png": "ed5b2566ce8c5ba7c3424c36909dac66",
"splash/img/dark-1x.png": "0e11ccf013220e6454618376d6512300",
"splash/img/dark-4x.png": "5b38eec5734ce800882796b901781f6d",
"splash/img/light-1x.png": "0e11ccf013220e6454618376d6512300",
"splash/img/light-2x.png": "997432f244fa18fc1b3bce575ef0968d",
"favicon.png": "6e4e6784456f71604d3aeb2e4dfba382",
"index.html": "22230a4cb4fcb12af840e139146cde91",
"/": "22230a4cb4fcb12af840e139146cde91",
"manifest.json": "feecab6b49deef9c9383c9e488c7b33e",
"flutter.js": "4b2350e14c6650ba82871f60906437ea"};
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
