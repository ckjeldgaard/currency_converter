import 'dart:async';
import 'dart:html';
import 'dart:indexed_db' as idb;

class DatabaseProvider {

  static final String CURRENCIES_DB = "currency";
  static final String CURRENCIES_STORE = "currencies";

  idb.Database _db;
  int _version = 1;

  idb.Database get db => _db;

  Future open() async {
    return window.indexedDB.open(CURRENCIES_DB, version: _version,
        onUpgradeNeeded: _onUpgradeNeeded)
        .then(_onDbOpened)
        .catchError(_onError);
  }

  void _onDbOpened(idb.Database db) {
    _db = db;
  }

  void _onUpgradeNeeded(idb.VersionChangeEvent e) {
    idb.Database db = (e.target as idb.OpenDBRequest).result;
    if (!db.objectStoreNames.contains(CURRENCIES_STORE)) {
      db.createObjectStore(CURRENCIES_STORE);
    }
  }

  void _onError(e) {
    print('An error occurred: {$e}');
  }
}