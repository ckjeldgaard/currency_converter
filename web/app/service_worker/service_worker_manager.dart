
import '../utils/JsPromise.dart';
import '../utils/js_options.dart';
import 'dart:async';
import 'dart:js' as js;

class ServiceWorkerManager {
  final js.JsObject _context;

  ServiceWorkerManager([js.JsObject context])
      : _context = context != null ? context : js.context;

  _assertServiceWorkerSupportOrThrow() {
    if (!(_context['navigator'] as js.JsObject).hasProperty("serviceWorker")) {
      throw new Exception("Service Worker isn't supported.");
    }
  }

  /// Registers the Service Worker at [url] with [scope].
  Future registerServiceWorker({String url: "./service-worker.js", String scope: "./"}) async {
    _assertServiceWorkerSupportOrThrow();
    js.JsObject opts = new JsOptions({"scope": scope}).toJsObject();
    js.JsObject serviceWorker = _context['navigator']['serviceWorker'];
    try {
      var result = await new JsPromise(serviceWorker.callMethod("register", [url, opts])).toFuture();
      print('Service worker registered');
      return result;
    } catch (e) {
      print('Service worker registration failed');
      throw e;
    }
  }
}