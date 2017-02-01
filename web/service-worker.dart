import 'package:currency_converter/serviceworker.dart';
import 'package:currency_converter/src/worker.dart';
import 'package:currency_converter/src/cache.dart' as swCache;
import 'dart:async';

main() {

  final String _CACHE_VERSION = 'v1';

  ServiceWorker sw = new ServiceWorker();

  sw.onInstall.listen((event) async {
    print("install");
    try {
      Cache cache = await swCache.caches.open(_CACHE_VERSION);
      cache.addAll(urls : ["http://api.fixer.io/latest"]);
    } catch (e) {
      print('Error in install handler: ' + e);
    }
  });

  sw.onActivate.listen((event) async {
    print("activate");
    List<String> cacheNames = await swCache.caches.keys();
    cacheNames.forEach((String cacheName) {
      print("cacheName = " + cacheName);
        if (cacheName != _CACHE_VERSION) {
          print("Deleting " + cacheName + " from cache");
          return caches.delete(cacheName);
        }
    });
  });

  sw.onFetch.listen((FetchEvent event){
    print("fetch");
    event.respondWith(swCache.caches.match(event.request).then((Response response) {
      print("event.request.url = " + event.request.url.toString());
      return getResponse(event.request);
    }));
  });
}

Future<Response> getResponse(Request r) async {
  Response response = await caches.match(r);
  if (response != null) {
    return response;
  }
  return fetch(request:r.clone());
}