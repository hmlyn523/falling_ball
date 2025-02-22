'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-512.png": "390a61a05d8e5e5c83f2b00a8a4738e9",
"icons/Icon-192.png": "28be48d815b518228568719e89fa087b",
"flutter_bootstrap.js": "1e667096a9a99d1061bdfff45d240a27",
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
"main.dart.js": "8d4fb65a286ad647bd1d9132a3b70c21",
"version.json": "2009e33ee92575714318bb93c345bb23",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/FontManifest.json": "949199ba5748a451cccb39ef2807c67a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "6004dd644a66cf355f13fa770a667cc4",
"assets/assets/images/back_foreground.png": "2dfc3a5c93945d706e29764b458f10ff",
"assets/assets/images/back_background.png": "8b86e0f4eb3a3ec4350f966951e4b471",
"assets/assets/images/3-icon.png": "3e3a63f60b3ea16355c2d1b2d56613a2",
"assets/assets/images/win.png": "45c99d49cda7def0a42eafe4c5586c2b",
"assets/assets/images/enemy_ball_height2.png": "6181e5240ddc9fd7ed1c82b86c0c4791",
"assets/assets/images/game_over.png": "498ad6b3a88e0d950b44737f6b567ab6",
"assets/assets/images/title.png": "d1ebc17cde12579ee0d61864182161e7",
"assets/assets/images/10-icon.png": "d678aae61a1063b392728d920683234c",
"assets/assets/images/connect_4.png": "e3f0b345ca72d36db9024a4e29d9c4c4",
"assets/assets/images/explosion.png": "63af14a4e1e4048dd57b4495a95c0d14",
"assets/assets/images/8-icon.png": "ef6da7d497a717c4130134b852d0dd70",
"assets/assets/images/rank_and_score.png": "b98ea2f6da36dc993cc629f41c800a97",
"assets/assets/images/empty.png": "65cbc3180b2ea1129110309f25bac1fc",
"assets/assets/images/connect_3.png": "168c09554646f28e2103f15324f12a6b",
"assets/assets/images/6-icon.png": "365ebf8a8f0414ac7f1408767ff6ab8f",
"assets/assets/images/2-icon.png": "63c0b5d2ea6e75ec7c3390b09f697c77",
"assets/assets/images/menu.png": "44df22660c0a98cafe79dcbbbdbc5614",
"assets/assets/images/11-icon.png": "906a9bb6777dfbaaf9c3b1e2aa33b595",
"assets/assets/images/1-icon.png": "cd6f04f9b067005076ae0226b90dc1db",
"assets/assets/images/choose_players.png": "4a839b05d588ee7788646dc6d5aa8de4",
"assets/assets/images/5-icon.png": "772f6e1aaf72f69536b6d9338352dfcd",
"assets/assets/images/connect_1.png": "f28c86e7bf3d3ab17dcccf22f24342b3",
"assets/assets/images/copyright.png": "72145ac3adffc2d7f961f471da4d3193",
"assets/assets/images/4-icon.png": "edc2e922396ef9590d0b8b3f60a7b547",
"assets/assets/images/ranking_dialog.png": "ccb792ac5ed6dc5aba30bfe06a5be9b0",
"assets/assets/images/enemy_ball_height3.png": "9d1ef831bc93ada98bfce54b07faadb4",
"assets/assets/images/12-icon.png": "a1a0565ba1236eeb449be2d48cc75f63",
"assets/assets/images/ranking.png": "f261c152a8a4260ae5ac069d5d0b36cc",
"assets/assets/images/tap_title.png": "e55f8c7a9563c37053222b7ab2da2fa3",
"assets/assets/images/multi3.png": "ee698fa6b7d1efb66450347f302252af",
"assets/assets/images/9-icon.png": "143a8cea8257f5e974d3c8002af1b40c",
"assets/assets/images/multi4.png": "981d36748c98ddaaa2bc231693805373",
"assets/assets/images/7-icon.png": "4d5ea736e04cc74fbdc72647b33a49e5",
"assets/assets/images/connect_2.png": "0263614d40b8a244efc223b951ece350",
"assets/assets/images/connect_0.png": "09da352fb62b700d53648366cf4a7918",
"assets/assets/images/cancel.png": "cf71b9066f3b011168e99ecfb3c1de70",
"assets/assets/images/start.png": "50fde35e7adc9f2911714ce327204899",
"assets/assets/images/score.png": "843a63cb136358f4ccdd3b11d78cb7ed",
"assets/assets/images/lose.png": "907bd1c5a815309bb0c88ffeedf85087",
"assets/assets/images/enemy_ball_height.png": "647bc05d3bd34c88a50c994a956667ca",
"assets/assets/images/back_background_game.png": "00206c0cf928afdf74c8c7bdb3a9438e",
"assets/assets/images/multi2.png": "b05eab73cbea76a8565a19167cb497cb",
"assets/assets/fonts/PressStart2P-Regular.ttf": "f98cd910425bf727bd54ce767a9b6884",
"assets/assets/fonts/Square-L.ttf": "6a85340d6fed400674984fbd4d9769ae",
"assets/assets/audio/bgm.wav": "4565dc5a70e6cec2d00d7780d9d14f68",
"assets/assets/audio/sfx/spawn.wav": "68a602aba9e33e519073ada25bdf77c5",
"assets/assets/audio/sfx/collision.wav": "d02ff42cfc310cf42ae8e9798e7e5563",
"assets/assets/audio/title.wav": "b9dc0b17db6d83bb335b0c6ca627715e",
"assets/assets/audio/bgm.mp3": "2720a15eb3340ca843d0c0a70f557e40",
"assets/NOTICES": "774655ec431a0494c8fd1d690a157e48",
"assets/AssetManifest.bin": "fadc05bc5c6e7cabac01b5c3544a1f99",
"assets/fonts/MaterialIcons-Regular.otf": "0db35ae7a415370b89e807027510caf0",
"assets/AssetManifest.bin.json": "241b9c819b7c5ec0d41040a57c316cd4",
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
