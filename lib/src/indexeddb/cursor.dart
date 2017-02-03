part of IndexedDB;

enum CursorDirection {
  NEXT,
  NEXT_UNIQUE,
  PREV,
  PREV_UNIQUE
}

class Cursor implements JsProxyObject {
  Cursor._internal(this._js) {

  }

  /// Sets the number times a cursor should move its position forward.

  void advance(int count) {
    _js.callMethod("advance",[count]);
  }

  /// Advances the cursor to the next position along its direction, to the item
  /// whose key matches the optional [key] parameter.

  void next([key]) {
    _js.callMethod("continue",key == null ? [] : [key]);
  }

  /// Deletes the record at the cursor's position, without changing the
  /// cursor's position. This can be used to delete specific records.

  Future delete() {
    Completer c = new Completer();
    JsObject request = _js.callMethod("delete");
    request["onsuccess"] = (e) {
      c.complete();
    };
    request["onerror"] = (e) {
      c.completeError(request["error"]);
    };
    return c.future;
  }

  /// Updates the value at the current position of the cursor in the
  /// object store. This can be used to update specific records.

  Future update() {
    Completer c = new Completer();
    JsObject request = _js.callMethod("update");
    request["onsuccess"] = (e) {
      c.complete();
    };
    request["onerror"] = (e) {
      c.completeError(request["error"]);
    };
    return c.future;
  }

  /// Returns the ObjectStore or Index that the cursor is iterating.
  /// This function never returns null or throws an exception, even
  /// if the cursor is currently being iterated, has iterated past
  /// its end, or its transaction is not active.

  get source {
    JsObject ret = _js["source"];
    if (ret.instanceof(context["IDBObjectStore"]))
      return new ObjectStore._internal(ret);
    if (ret.instanceof(context["IDBIndex"]))
      return new Index._internal(ret);
    return ret;
  }

  /// Returns the direction of traversal of the cursor.

  CursorDirection get direction {
    String ret = _js["direction"];
    if (ret == "nextunique") return CursorDirection.NEXT_UNIQUE;
    if (ret == "prev") return CursorDirection.PREV;
    if (ret == "prevunique") return CursorDirection.PREV_UNIQUE;
    return CursorDirection.NEXT;
  }

  /// Returns the key for the record at the cursor's position. If the cursor
  /// is outside its range, this is set to undefined. The cursor's key can
  /// be any data type.

  String get key => _js["key"];

  /// Returns the cursor's current effective primary key. If the cursor is
  /// currently being iterated or has iterated outside its range,
  /// this is set to undefined. The cursor's primary key can be any data type.

  String get primaryKey => _js["key"];

  JsObject toJs() => _js;

  JsObject _js;
}

class CursorWithValue extends Cursor {
  CursorWithValue._internal(js) : super._internal(js) {

  }

  /// Returns the value of the current cursor.

  get value => _js["value"];
}
