'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js": "7a2608cc18cd033841b2dfe74304ce7d",
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
"assets/AssetManifest.bin": "bde5ea94534afffe6f7d2f53d9f89986",
"assets/fonts/MaterialIcons-Regular.otf": "c0ad29d56cfe3890223c02da3c6e0448",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/assets/fonts/Square-L.ttf": "6a85340d6fed400674984fbd4d9769ae",
"assets/assets/images/connect_3.png": "87cc59edadb6054c3be194ea929a143d",
"assets/assets/images/12-icon.png": "202bddefb1ff536512a0af7e87cfae25",
"assets/assets/images/back_background.png": "148ee905ab9898dbb63be033ec5b16ac",
"assets/assets/images/empty.png": "65cbc3180b2ea1129110309f25bac1fc",
"assets/assets/images/explosion.png": "63af14a4e1e4048dd57b4495a95c0d14",
"assets/assets/images/copyright.png": "b3f9d96d2709388e21d4d14cdcb7e9f1",
"assets/assets/images/enemy_ball_height2.png": "740ca24bb8a7ef350f853b3bde0c6cda",
"assets/assets/images/10-icon.png": "672748d10cc20a76cc1151d16b435c00",
"assets/assets/images/11-icon.png": "428cba9ceacba10484cb3869a97cefd1",
"assets/assets/images/8-icon.png": "0de845a970cfac21b4d577cbd0037d78",
"assets/assets/images/connect_1.png": "1d9db14e36204a0b7a9a624ebc7ea3cd",
"assets/assets/images/cancel.png": "76fb7f5fc1add8d19d7fd319a8afc450",
"assets/assets/images/connect_2.png": "c6785721173379966852b1f2067a0576",
"assets/assets/images/multi3.png": "c907aaf11f0825d0bef11ca0b433cf29",
"assets/assets/images/2-icon.png": "f0b6c96cb0837a6d0ba2c8e9dd784a05",
"assets/assets/images/1-icon.png": "e40868bc2d962958b822d18e9790567f",
"assets/assets/images/start.png": "b14b5804410bedb2a52aff3b08a65a11",
"assets/assets/images/connect_0.png": "89b86c6c1ceb1c36b0ccd213fcdf659d",
"assets/assets/images/menu.png": "751bddafea4540a7ff52a1827c76cd61",
"assets/assets/images/lose.png": "5b2b3155eaa68f2d91834a49b372fafd",
"assets/assets/images/post.png": "61b29a978f9ae35d8804ccfd9ab30898",
"assets/assets/images/ranking.png": "dccb336a27a6a0ba73c695a1ba9bbc54",
"assets/assets/images/enemy_ball_height.png": "db07c6fb3b8d3c255640c1d2d2a25b5b",
"assets/assets/images/7-icon.png": "daf9323d84f5ae11ae8ed6315825aa01",
"assets/assets/images/back_foreground.png": "2dfc3a5c93945d706e29764b458f10ff",
"assets/assets/images/5-icon.png": "63a2268c814bb84cc7b135045e73c298",
"assets/assets/images/title.png": "61b7199eb29c28fc2de084d93db8f849",
"assets/assets/images/4-icon.png": "35e53a489e675bb1b0d989c5063a6608",
"assets/assets/images/6-icon.png": "3696e71edc10e8954a2804fdf79563db",
"assets/assets/images/9-icon.png": "b48915af82a0193456feab9e0921a7af",
"assets/assets/images/connect_4.png": "93d4d474badb8ed3c8364f01c2bd774d",
"assets/assets/images/game_over.png": "ad64819fc2a064a5af7764a7ca71111c",
"assets/assets/images/3-icon.png": "4334d0215405820612ac5dec91e8229b",
"assets/assets/images/tap_title.png": "ea8d178ffee813c471763936f012afb9",
"assets/assets/images/win.png": "5353a81940ec799d6c27c3eab02d95be",
"assets/assets/images/multi2.png": "c00ff3758a0be01de8f4a1feb9029122",
"assets/assets/audio/bgm.mp3": "2720a15eb3340ca843d0c0a70f557e40",
"assets/assets/audio/sfx/spawn.wav": "68a602aba9e33e519073ada25bdf77c5",
"assets/assets/audio/sfx/collision.wav": "d02ff42cfc310cf42ae8e9798e7e5563",
"assets/assets/audio/bgm.wav": "4565dc5a70e6cec2d00d7780d9d14f68",
"assets/assets/audio/title.wav": "b9dc0b17db6d83bb335b0c6ca627715e",
"assets/NOTICES": "e4351518f1ed182b7dcebf93dd9d467a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "aa6ca431fb3c358ab4af9907521b2704",
"assets/AssetManifest.bin.json": "462317690cac048497e4ab032a419d23",
"index.html": "62654595743065158cb0d1d987e4424f",
"/": "62654595743065158cb0d1d987e4424f",
"manifest.json": "5a662627713f86a3c441bec36d415bca",
"canvaskit/canvaskit.js": "de27f912e40a372c22a069c1c7244d9b",
"canvaskit/canvaskit.js.symbols": "ff204c6b77c9e5969d85d9bfbaa0c843",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/chromium/canvaskit.js": "73343b0c5d471d1114d7f02e06c1fdb2",
"canvaskit/chromium/canvaskit.js.symbols": "85275e659470daa080e014ffe17a1a59",
"canvaskit/chromium/canvaskit.wasm": "86233631b867ce8f74c2020077650d11",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm_st.js.symbols": "a564f5dfbd90292f0f45611470170fe1",
"canvaskit/skwasm.js.symbols": "c7cf698f802bc5e9e8e791f762ebdfe9",
"canvaskit/canvaskit.wasm": "2e9895626fe95683569ed951214f1eb8",
"canvaskit/skwasm.wasm": "c528f7ba97a317e25e547ea47c8a66d8",
"canvaskit/skwasm_st.wasm": "3179a61ea4768a679dbbe30750d75214",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "2009e33ee92575714318bb93c345bb23",
"flutter_bootstrap.js": "3e527df269b94767d7c641d737b8c2fd"};
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
