import '../data/database_provider.dart';
import 'currencies.dart';
import 'currencies_iterator.dart';
import 'currency.dart';
import 'default_currency.dart';
import 'dart:indexed_db' as idb;

class StoredCurrencies extends Currencies {

  final idb.Database _db;
  List<Currency> _currencies;

  StoredCurrencies(this._db) {
    this._currencies = new List();
    this._currencies.add(new DefaultCurrency("USD", 1.0));
    this._currencies.add(new DefaultCurrency("EUR", 2.0));
  }

  @override
  Iterator<Currency> get iterator => new CurrenciesIterator(_loadFromDb());

  List<Currency> _loadFromDb() {
    List<Currency> currencies = new List();
    idb.Transaction trans = _db.transaction(DatabaseProvider.CURRENCIES_STORE, 'readwrite');
    idb.ObjectStore store = trans.objectStore(DatabaseProvider.CURRENCIES_STORE);

    var cursors = store.openCursor(autoAdvance: true).asBroadcastStream();
    cursors.listen((cursor) {
      print(cursor.value);
    });

    /*
    return cursors.length.then((_) {
      return milestones.length;
    });

    // Get everything in the store.
    var request = store.openCursor(autoAdvance:true).listen((cursor) {
      //currencies.add(cursor.value);
      print(cursor.value);
    }, onError: _onError);
*/
    return currencies;
  }

  @override
  Currency add(String code, double rate) {
    // TODO: implement add
    return null;
  }

  void _onError(e) {
    print('An error occurred: {$e}');
  }
}