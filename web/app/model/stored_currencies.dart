import '../data/database_provider.dart';
import 'currencies.dart';
import 'currency.dart';
import 'dart:async';
import 'default_currency.dart';
import 'dart:indexed_db' as idb;

class StoredCurrencies implements Currencies {

  final idb.Database _db;
  List<Currency> _currencies;

  StoredCurrencies(this._db) {
    if (this._db == null) {
      throw new ArgumentError("Database cannot be null!");
    }
    this._currencies = new List();
  }

  @override
  Future<List<Currency>> getCurrencies() async {
    await _loadFromDb();
    return _currencies;
  }

  @override
  void add(Currency currency) {
    idb.Transaction trans = _db.transaction(DatabaseProvider.CURRENCIES_STORE, 'readwrite');
    idb.ObjectStore store = trans.objectStore(DatabaseProvider.CURRENCIES_STORE);
    store.put(currency.rate, currency.code).catchError((e) => _onError);
  }

  Future<List<Currency>> _loadFromDb() async {
    List<Currency> currencies = new List();
    idb.Transaction trans = _db.transaction(DatabaseProvider.CURRENCIES_STORE, 'readwrite');
    idb.ObjectStore store = trans.objectStore(DatabaseProvider.CURRENCIES_STORE);

    var cursors = store.openCursor(autoAdvance: true).asBroadcastStream();
    cursors.listen((cursor) {
      currencies.add(new DefaultCurrency(cursor.key, cursor.value));
    });

    return cursors.length.then((_) {
      _currencies = currencies;
      return _currencies;
    });
  }

  void _onError(e) {
    print('An error occurred: {$e}');
  }
}