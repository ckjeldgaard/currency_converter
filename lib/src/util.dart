library DSWUtil;

import 'dart:js';
import 'dart:async';

abstract class JsProxyObject {
  JsObject toJs();
}

class Promise implements JsProxyObject {
  Promise.fromFuture(Future f) {
    var exec = (resolve,reject){
      _resolve = resolve;
      _reject = reject;
      _ready.complete();
    };
    _internal = new JsObject(context["Promise"],[exec]);
    f.then((v) async {
      var ret = (v is JsProxyObject) ? v.toJs() : v;
      await _ready.future;
      _resolve.apply([ret]);
    }).catchError((e) async {
      await _ready.future;
      _reject.apply([]);
    });
  }

  JsObject toJs() => _internal;

  JsFunction _resolve;
  JsFunction _reject;
  JsObject _internal;
  Completer _ready = new Completer();
}
