
import 'package:currency_converter/serviceworkermanager.dart' as SW;

import 'dart:async';

class ServiceWorkerManager {

  ServiceWorkerManager();

  Future registerServiceWorker() async {
    try {
      SW.ServiceWorker sw = await SW.serviceWorkerManager.register("service-worker.dart.js");
      print("registered");
      sw.onMessage.listen((SW.MessageEvent e){
        print(e.data);
      });
    } catch(e) {
      print(e);
    }
  }

}