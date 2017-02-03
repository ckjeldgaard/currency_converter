library IndexedDB;

import 'dart:js';
import 'util.dart';
import 'dart:async';

part 'indexeddb/database.dart';
part 'indexeddb/keyrange.dart';
part 'indexeddb/index.dart';
part 'indexeddb/cursor.dart';
part 'indexeddb/objectstore.dart';
part 'indexeddb/transaction.dart';

Future _requestCall(JsObject caller, String fn, List args,
    {bool useResult: false}) {
  Completer c = new Completer();
  JsObject request = caller.callMethod(fn, args);
  request["onsuccess"] = (e) {
    if (useResult)
      c.complete(request["result"]);
    else
      c.complete();
  };
  request["onerror"] = (e) {
    c.completeError(request["error"]);
  };
  return c.future;
}

final IndexedDB indexedDB = context.hasProperty("window")
    ? new IndexedDB._internal(new JsObject.fromBrowserObject(
        new JsObject.fromBrowserObject(context["window"])["indexedDB"]))
    : new IndexedDB._internal(context["indexedDB"]);

enum AccessMode { READ_ONLY, READ_WRITE }

class IndexedDB implements JsProxyObject {
  IndexedDB._internal(this._js) {}

  /// The current method to request opening a connection to a database.

  Future<Database> open(String name,
      {int version,
      void onUpgradeNeeded(VersionChangeEvent),
      void onBlocked(dynamic)}) {
    var vars = [name];
    if (version != null) vars.add(version);
    JsObject request = _js.callMethod("open", vars);
    Completer c = new Completer();

    if (onUpgradeNeeded != null) {
      request["onupgradeneeded"] = (e) {
        var event = new JsObject.fromBrowserObject(e);
        onUpgradeNeeded(new VersionChangeEvent(
            event["oldVersion"],
            event["newVersion"],
            new Database._internal(event["target"]["result"])));
      };
    }

    if (onBlocked != null) {
      request["onblocked"] = (event) {
        onBlocked(event);
      };
    }

    request["onerror"] = (JsObject event) {
      c.completeError("Error opening database.");
    };

    request["onsuccess"] = (JsObject event) {
      c.complete(new Database._internal(request["result"]));
    };

    return c.future;
  }

  /// A method to request the deletion of a database.

  Future deleteDatabase(String name, {void onBlocked(dynamic)}) {
    var vars = [name];
    JsObject request = _js.callMethod("deleteDatabase", vars);
    Completer c = new Completer();

    if (onBlocked != null) {
      request["onblocked"] = (event) {
        onBlocked(event);
      };
    }

    request["onerror"] = (JsObject event) {
      c.completeError("Error deleting database.");
    };

    request["onsuccess"] = (JsObject event) {
      c.complete();
    };

    return c.future;
  }

  /// A method that compares two keys and returns a result indicating which
  /// one is greater in value.

  int cmp(first,second) => _js.callMethod("cmd",[first,second]);

  JsObject toJs() => _js;

  JsObject _js;
}

class VersionChangeEvent {
  VersionChangeEvent(this.oldVersion, this.newVersion, this.database) {}
  final int oldVersion;
  final int newVersion;
  final Database database;
}
