import '../data/local_storage.dart';
import 'dart:html';
import 'dart:js';
import 'package:currency_converter/serviceworkermanager.dart' as SW;

import 'dart:async';

class ServiceWorkerManager {

  static final int _THREE_DAYS_MILLS = 259200000;
  final LocalStorage _localStorage;

  ServiceWorkerManager(this._localStorage);

  Future registerServiceWorker() async {
    try {
      SW.ServiceWorker sw = await SW.serviceWorkerManager.register("service-worker.dart.js");
      print("registered");

      sw.onMessage.listen((SW.MessageEvent e){
        JsObject jsData = e.data["o"];
        JsObject updateNotification = jsData["data"];
        var eventTimestamp = updateNotification["_timestamp"];
        int delta = (eventTimestamp - _localStorage.getCurrentTimestamp());

        // Reload page if older than 3 days:
        if (delta > _THREE_DAYS_MILLS) {
          window.location.reload();
        }
      });
    } catch(e) {
      print(e);
    }
  }

}