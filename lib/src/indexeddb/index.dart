part of IndexedDB;

class Index implements JsProxyObject {
  Index._internal(this._js) {

  }

  /// Returns the number of records within a key range.

  Future<int> count(key_OR_Range) {
    Completer c = new Completer();
    var jvar = (key_OR_Range is KeyRange)
        ? (key_OR_Range as KeyRange).toJs()
        : key_OR_Range;
    JsObject request = _js.callMethod("count", [jvar]);
    request["onsuccess"] = (e) {
      c.complete(request["result"]);
    };
    request["onerror"] = (e) {
      c.completeError(request["error"]);
    };
    return c.future;
  }

  /// Finds either the value in the referenced object store that corresponds
  /// to the given key or the first corresponding value,
  /// if key is an `KeyRange`.

  Future get(key_OR_Range) {
    Completer c = new Completer();
    var jvar = (key_OR_Range is KeyRange)
        ? (key_OR_Range as KeyRange).toJs()
        : key_OR_Range;
    JsObject request = _js.callMethod("get", [jvar]);
    request["onsuccess"] = (e) {
      c.complete(request["result"]);
    };
    request["onerror"] = (e) {
      c.completeError(request["error"]);
    };
    return c.future;
  }

  /// Finds all matching values in the referenced object store that
  /// correspond to the given key or are in range, if key is an `KeyRange`.

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

  /// Finds all matching keys in the referenced object store that correspond
  /// to the given key or are in range, if key is an `KeyRange`.

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

  /// Creates a cursor over the specified key range.

  Future<CursorWithValue> openCursor(
      {key, KeyRange range, CursorDirection direction}) {
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

    Completer c = new Completer();
    JsObject request = _js.callMethod("openCursor", vars);
    request["onsuccess"] = (e) {
      c.complete(new CursorWithValue._internal(request["result"]));
    };
    request["onerror"] = (e) {
      c.completeError(request["error"]);
    };
    return c.future;
  }

  /// Creates a cursor over the specified key range, as arranged by this index.

  Future<CursorWithValue> openKeyCursor(
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

    Completer c = new Completer();
    JsObject request = _js.callMethod("openKeyCursor", vars);
    request["onsuccess"] = (e) {
      c.complete(new CursorWithValue._internal(request["result"]));
    };
    request["onerror"] = (e) {
      c.completeError(request["error"]);
    };
    return c.future;
  }

  JsObject toJs() => _js;
  JsObject _js;
}
