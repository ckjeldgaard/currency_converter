import 'dart:html';
import 'dart:js';
import 'package:currency_converter/serviceworkermanager.dart' as SW;

import 'dart:async';

class ServiceWorkerManager {

  ServiceWorkerManager();

  Future registerServiceWorker() async {
    try {
      SW.ServiceWorker sw = await SW.serviceWorkerManager.register("service-worker.dart.js");
      print("registered");

      sw.onMessage.listen((SW.MessageEvent e){
        JsObject jsData = e.data["o"];
        JsObject updateNotification = jsData["data"];
        var eventTimestamp = updateNotification["_timestamp"];
        int currentTimestamp = new DateTime.now().millisecondsSinceEpoch;
        int delta = (eventTimestamp - currentTimestamp);

        print("eventTimestamp   = " + eventTimestamp.toString());
        print("currentTimestamp = " + currentTimestamp.toString());
        print("eventTimestamp - currentTimestamp = " + delta.toString());

        if (eventTimestamp - currentTimestamp > 4*60*60*1000) {
          window.location.reload();
        }
      });
    } catch(e) {
      print(e);
    }
  }

}