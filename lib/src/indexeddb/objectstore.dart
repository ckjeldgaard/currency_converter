part of IndexedDB;

class ObjectStore implements JsProxyObject {
  ObjectStore._internal(this._js) {}

  /// Creates a structured clone of the value, and stores the cloned value in
  /// the object store. This is for adding new records to an object store.

  Future add(value,{key}) {
    Completer c = new Completer();
    if (value is Map || value is List) value = new JsObject.jsify(value);
    var vars = [value];
    if (key != null) vars.add(key);
    JsObject request = _js.callMethod("add", vars);
    request["onsuccess"] = (e) {
      c.complete();
    };
    request["onerror"] = (e) {
      c.completeError(request["error"]);
    };
    return c.future;
  }

  /// Clears this object store. This is for deleting all current records
  /// out of an object store.

  Future clear(key) {
    Completer c = new Completer();
    JsObject request = _js.callMethod("clear", [key]);
    request["onsuccess"] = (e) {
      c.complete();
    };
    request["onerror"] = (e) {
      c.completeError(request["error"]);
    };
    return c.future;
  }

  Future clearRange(KeyRange range) {
    Completer c = new Completer();
    JsObject request = _js.callMethod("clear", [range.toJs()]);
    request["onsuccess"] = (e) {
      c.complete();
    };
    request["onerror"] = (e) {
      c.completeError(request["error"]);
    };
    return c.future;
  }

  /// Returns the total number of records that match the provided
  /// key or `KeyRange`. If no arguments are provided, it returns the total
  /// number of records in the store.

  Future<int> count(key) {
    Completer c = new Completer();
    JsObject request = _js.callMethod("count", [key]);
    request["onsuccess"] = (e) {
      c.complete(request["result"]);
    };
    request["onerror"] = (e) {
      c.completeError(request["error"]);
    };
    return c.future;
  }

  Future<int> countRange(KeyRange range) => _requestCall(_js, "result", [range.toJs()], useResult: true);

  /// Deletes the store object selected by the specified key.
  /// This is for deleting individual records out of an object store.

  Future delete(String key) => _requestCall(_js, "delete", [key]);

  /// Deletes the store object selected by the specified range.
  /// This is for deleting individual records out of an object store.

  Future deleteRange(KeyRange range) => _requestCall(_js, "delete", [range.toJs()]);

  /// Returns the store object store selected by the specified key.
  /// This is for retrieving specific records from an object store.

  Future get(String key) => _requestCall(_js, "get", [key], useResult: true);

  /// Returns the store object store selected by the specified range.
  /// This is for retrieving specific records from an object store.

  Future getRange(KeyRange range) => _requestCall(_js, "get", [range.toJs()], useResult: true);

  /// Retrieves all objects in the object store matching the specified
  /// parameter or all objects in the store if no parameters are given.

  Future<List> getAll(key_OR_Range, {int count}) {
    Completer c = new Completer();
    var jvar = (key_OR_Range is KeyRange)
        ? (key_OR_Range as KeyRange).toJs()
        : key_OR_Range;
    var jvars = [jvar];
    if (count != null) jvars.add(count);
    JsObject request = _js.callMethod("getAll", jvars);
    request["onsuccess"] = (e) {
      JsArray ret = request["result"];
      c.complete(ret.toList());
    };
    request["onerror"] = (e) {
      c.completeError(request["error"]);
    };
    return c.future;
  }

  /// Retrieves record keys for all objects in the object store matching
  /// the specified parameter or all objects in the store if no parameters
  /// are given.

  Future<List<String>> getAllKeys(KeyRange range, {int count}) {
    Completer c = new Completer();
    var jvars = [range.toJs()];
    if (count != null) jvars.add(count);
    JsObject request = _js.callMethod("getAllKeys", jvars);
    request["onsuccess"] = (e) {
      JsArray ret = request["result"];
      c.complete(ret.toList());
    };
    request["onerror"] = (e) {
      c.completeError(request["error"]);
    };
    return c.future;
  }

  /// Creates a new index during a version upgrade,
  /// returning a new `Index` object in the connected database.

  Index createIndex(String indexName, String keyPath,
      {bool unique, bool multiEntry}) {
    var options = {};
    if (unique != null) options["unique"] = unique;
    if (multiEntry != null) options["multiEntry"] = multiEntry;
    var ret = _js.callMethod(
        "createIndex", [indexName, keyPath, new JsObject.jsify(options)]);
    return new Index._internal(ret);
  }

  /// Destroys the specified index in the connected database,
  /// used during a version upgrade.

  void deleteIndex(String indexName) {
    _js.callMethod("deleteIndex", [indexName]);
  }

  /// Opens an index from this object store after which it can, for example,
  /// be used to return a sequence of records sorted by that index
  /// using a cursor.

  Index index(String indexName) {
    return new Index._internal(_js.callMethod("index", [indexName]));
  }

  /// Returns a new IDBCursorWithValue object. Used for iterating through an
  /// object store by primary key with a cursor.

  Stream<CursorWithValue> openCursor(
      {String key, KeyRange range, CursorDirection direction}) {
    var vars = [];
    if (key != null || range != null) {
      vars.add(key != null ? key : range);
    }
    if (direction != null) {
      String dir = "next";
      if (direction == CursorDirection.NEXT_UNIQUE) dir = "nextunique";
      if (direction == CursorDirection.PREV) dir = "prev";
      if (direction == CursorDirection.PREV_UNIQUE) dir = "prevunique";
      vars.add(dir);
    }

    StreamController c = new StreamController();
    JsObject request = _js.callMethod("openCursor", vars);
    request["onsuccess"] = (e) {
      if (request["result"] == null)
        c.close();
      else
        c.add(new CursorWithValue._internal(request["result"]));
    };
    request["onerror"] = (e) {
      //c.completeError(request["error"]);
      c.close();
    };
    return c.stream;
  }

  /// Returns a new IDBCursorWithValue. Used for iterating through
  /// an object store with a key.

  Stream<CursorWithValue> openKeyCursor(
      {KeyRange range, CursorDirection direction}) {
    var vars = [];
    if (range != null) {
      vars.add(range);
    }
    if (direction != null) {
      String dir = "next";
      if (direction == CursorDirection.NEXT_UNIQUE) dir = "nextunique";
      if (direction == CursorDirection.PREV) dir = "prev";
      if (direction == CursorDirection.PREV_UNIQUE) dir = "prevunique";
      vars.add(dir);
    }

    StreamController c = new StreamController();
    JsObject request = _js.callMethod("openKeyCursor", vars);
    request["onsuccess"] = (e) {
      if (request["result"] == null)
        c.close();
      else
        c.add(new CursorWithValue._internal(request["result"]));
    };
    request["onerror"] = (e) {
      //c.completeError(request["error"]);
      c.close();
    };
    return c.stream;
  }

  /// Creates a structured clone of the value, and stores the cloned value in
  /// the object store. This is for updating existing records in an object
  /// store when the transaction's mode is readwrite.

  Future put(value, {key}) {
    return _requestCall(_js, "put", [value,key]);
  }

  /// The value of the auto increment flag for this object store.

  bool get autoIncrement => _js["autoIncrement"];

  /// A list of the names of indexes on objects in this object store.

  List<String> get indexNames => (_js["indexNames"] as JsArray).toList();

  /// The key path of this object store. If this attribute is null,
  /// the application must provide a key for each modification operation.

  String get keyPath => _js["keyPath"];

  /// The name of this object store.

  String get name => _js["name"];

  /// Set the name of this object store.

  void set name(String name) {
    _js["name"] = name;
  }

  /// The `Transaction` object to which this object store belongs.

  Transaction get transaction => new Transaction._internal(_js["transaction"]);

  JsObject toJs() => _js;

  JsObject _js;
}
