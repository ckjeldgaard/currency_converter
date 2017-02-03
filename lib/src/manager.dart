library ServiceWorkerManager.Manager;

import 'dart:async';
import 'dart:js';
import 'dart:html' as HTML;
import 'workerinterface.dart';

final ServiceWorkerManager serviceWorkerManager = new ServiceWorkerManager();

class ServiceWorkerManager {
  Future<ServiceWorker> register(String scriptUrl) {
    _register = new Completer();
    JsObject nav = new JsObject.fromBrowserObject(
            (new JsObject.fromBrowserObject(context['window']))["navigator"]);
    if (nav.hasProperty("serviceWorker")) {
      JsObject sw = new JsObject.fromBrowserObject(nav["serviceWorker"]);
      JsObject swf = sw.callMethod("register",[scriptUrl]);
      JsObject swfr = swf.callMethod("then",[(reg){
        ServiceWorker sw = new ServiceWorker.internal(reg);
        _register.complete(sw);
      }]);
      //swfr.callMethod(method)
    } else {
      throw "Not supported";
    }
    return _register.future;

    /*var reg =
        await HTML.window.navigator.serviceWorker.register(scriptUrl);
        print(reg);
    ServiceWorker sw = new ServiceWorker.internal(reg);
    return sw;*/
  }

  Completer _register;
}
