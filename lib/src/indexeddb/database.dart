part of IndexedDB;

class Database implements JsProxyObject {
  Database._internal(this._js) {
    _js["onabort"] = (e) {
      _onAbort.add(e);
    };

    _js["onclose"] = (e) {
      _onClose.add(e);
    };

    _js["onerror"] = (e) {
      _onError.add(e);
    };

    _js["onversionchange"] = (e) {
      _onVersionChange.add(e);
    };
  }

  void close() {}

  ObjectStore createObjectStore(String name,
      {String keyPath, bool autoIncrement}) {
    var options = {};
    if (keyPath != null) options["keyPath"] = keyPath;
    if (autoIncrement != null) options["autoIncrement"] = autoIncrement;
    try {
      JsObject ret = _js
          .callMethod("createObjectStore", [name, new JsObject.jsify(options)]);
      return new ObjectStore._internal(ret);
    } catch (e) {
      throw e.toString();
    }
  }

  void deleteObjectStore(String name) =>
      _js.callMethod("deleteObjectStore", [name]);

  Transaction transaction(List<String> storeNames, AccessMode mode) {
    String modestr = "readonly";
    if (mode == AccessMode.READ_WRITE) modestr = "readwrite";
    return new Transaction._internal(
        _js.callMethod("transaction", [new JsArray.from(storeNames), modestr]));
  }

  String get name => _js["name"];
  List<String> get objectStoreNames => (_js["objectStoreNames"] as JsArray).toList();

  Stream get onAbort => _onAbort.stream;
  Stream get onClose => _onClose.stream;
  Stream get onError => _onError.stream;
  Stream get onVersionChange => _onVersionChange.stream;

  String get version => _js["version"];

  JsObject toJs() => _js;

  StreamController _onAbort = new StreamController.broadcast();
  StreamController _onClose = new StreamController.broadcast();
  StreamController _onError = new StreamController.broadcast();
  StreamController _onVersionChange = new StreamController.broadcast();

  JsObject _js;
}
