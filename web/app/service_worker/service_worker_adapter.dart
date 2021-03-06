import '../data/local_storage.dart';
import 'dart:html';
import 'dart:js';
import 'package:currency_converter/serviceworkermanager.dart' as SW;

import 'dart:async';

class ServiceWorkerAdapter {

  static final int _THREE_DAYS_MILLS = 259200000;
  final LocalStorage _localStorage;

  ServiceWorkerAdapter(this._localStorage);

  Future registerServiceWorker() async {
    try {
      SW.ServiceWorker sw = await SW.serviceWorkerManager.register("service-worker.dart.js");
      print("registered");

      sw.onMessage.listen((SW.MessageEvent e){
        JsObject jsData = e.data["o"];
        JsObject updateNotification = jsData["data"];
        var eventTimestamp = updateNotification["_timestamp"];
        int delta = (eventTimestamp - _localStorage.getCurrentTimestamp());

        // Reload page if cached version is older
        if (delta > 0) {
          window.location.reload();
        }
      });
    } catch(e) {
      print(e);
    }
  }

}