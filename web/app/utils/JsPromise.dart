import "dart:js" as js;
import 'dart:async';

class JsPromise {

  final js.JsObject _promise;

  JsPromise(this._promise);

  Future toFuture() {
    Completer completer = new Completer();

    _promise.callMethod("then", [
          (Object value) {
        completer.complete(value);
      }
    ]).callMethod("catch", [
          (Object err) {
        completer.completeError(err);
      }
    ]);

    return completer.future;
  }

}