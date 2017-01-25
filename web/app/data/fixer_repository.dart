import '../model/currency.dart';
import '../model/default_currency.dart';
import '../model/stored_currencies.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'database_provider.dart';
import 'repository.dart';

class FixerRepository implements Repository {

  final String _apiUrl;
  final DatabaseProvider _databaseProvider;

  FixerRepository(this._apiUrl, this._databaseProvider);

  @override
  Future getCurrencyData() async {

    await _databaseProvider.open();

    StoredCurrencies storedCurrencies = new StoredCurrencies(_databaseProvider.db);
    List<Currency> loadedCurrencies = await storedCurrencies.getCurrencies().then((currencies) async {
      if (currencies.length == 0) {
        List<Currency> networkCurrencies = await _loadFromNetwork();
        storedCurrencies.addAll(networkCurrencies);
      }
      return currencies;
    });

    return loadedCurrencies;
  }

  Future<List<Currency>> _loadFromNetwork() async {
    try {
      String dataResponse = await HttpRequest.getString(_apiUrl);
      return _parseJsonData(dataResponse);
    } catch (e) {
      throw e;
    }
  }

  List<Currency> _parseJsonData(String dataResponse) {
    List<Currency> currencies = new List();
    currencies.add(new DefaultCurrency("EUR", 1.0));
    Map json = JSON.decode(dataResponse);
    json["rates"].forEach((code, rate) => currencies.add(new DefaultCurrency(code, rate)));
    currencies.sort((a, b) => a.compareTo(b));
    return currencies;
  }
}