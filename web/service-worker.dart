import 'package:currency_converter/serviceworker.dart';
import 'package:currency_converter/src/worker.dart';
import 'package:currency_converter/src/cache.dart' as swCache;
import 'dart:async';

main() {
  final String _CACHE_VERSION = 'v1';

  ServiceWorker sw = new ServiceWorker();

  sw.onInstall.listen((event) async {
    try {
      Cache cache = await swCache.caches.open(_CACHE_VERSION);
      cache.addAll(urls: [
        "index.html",
        "css/mui.min.css",
        "css/styles.css",
        "js/mui.min.js",
        "packages/browser/dart.js",
        "main.dart.js",
        "http://api.fixer.io/latest"
      ]);
    } catch (e) {
      print('Error in install handler: ' + e);
    }
  });

  sw.onActivate.listen((event) async {
    print("activate");
    List<String> cacheNames = await swCache.caches.keys();
    cacheNames.forEach((String cacheName) {
      if (cacheName != _CACHE_VERSION) {
        return caches.delete(cacheName);
      }
    });
  });

  sw.onFetch.listen((FetchEvent event) async {
    print("fetch. event.request.url = " + event.request.url.toString());
    if (event.request.url.contains("api.fixer.io")) {
      event.respondWith(
          swCache.caches.open(_CACHE_VERSION).then((Cache cache) async {
          Response response = await cache.match(request: event.request);
          if (response.ok) {
            fetchAndCache(event, cache).then((Response r) {
              sendUpdateNotification(sw, r);
            });
            return response;
          } else {
            return fetchAndCache(event, cache);
          }
        }).catchError((error) {
          print("Error in fetch handler: " + error.toString());
          throw error;
        })
      );
    } else {
      event.respondWith(
          swCache.caches.match(event.request).then((Response response) {
        return getResponse(event.request);
      }));
    }
  });

  sw.onMessage.listen((MessageEvent e){
    print("msg:"+e.data);
  });
}

Future<Response> fetchAndCache(FetchEvent event, Cache cache) async {
  return fetch(request: event.request.clone()).then((Response response) {
    if (response.status < 400) {
      cache.put(event.request, response.clone());
    }
    return response;
  });
}

Future<Response> getResponse(Request r) async {
  Response response = await caches.match(r);
  if (response != null) {
    return response;
  }
  return fetch(request: r.clone());
}

Future sendUpdateNotification(ServiceWorker sw, Response value) async {

  Map updateNotification = new Map<String, int>();
  updateNotification["timestamp"] = new DateTime.now().millisecondsSinceEpoch;

  List<ServiceWorkerClient> clients = await sw.clients();

  clients.forEach((ServiceWorkerClient client) {
    print("Sending HELLO to client " + client.toString() + " with ID = " + client.id);
    client.postMessage(new MessageEvent("HELLO", "", "", ""));
  });
}
