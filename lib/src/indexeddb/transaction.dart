part of IndexedDB;


class Transaction implements JsProxyObject {
  JsObject _js;
  StreamController _onAbort = new StreamController.broadcast();
  StreamController _onComplete = new StreamController.broadcast();
  StreamController _onError = new StreamController.broadcast();

  Transaction._internal(this._js) {
    _js["onabort"] = (event) {
      _onAbort.add(event);
    };

    _js["oncomplete"] = (event) {
      _onComplete.add(event);
    };

    _js["onerror"] = (event) {
      _onError.add(event);
    };
  }

  void abort() {
    _js.callMethod("abort");
  }

  ObjectStore objectStore(String name) =>
      new ObjectStore._internal(_js.callMethod("objectStore",[name]));

  Database get db => new Database._internal(_js["db"]);

  AccessMode get mode {
    String mode = _js["mode"];
    if (mode == "readwrite") return AccessMode.READ_WRITE;
    return AccessMode.READ_ONLY;
  }

  List<String> get objectStoreNames {
    JsArray namesjs = _js["objectStoreNames"];
    return namesjs.toList();
  }

  Stream get onAbort => _onAbort.stream;

  Stream get onComplete => _onComplete.stream;

  Stream get onError => _onError.stream;

  JsObject toJs() => _js;
}
