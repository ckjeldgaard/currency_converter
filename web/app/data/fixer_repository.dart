import '../model/currency.dart';
import '../model/default_currency.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'repository.dart';

class FixerRepository implements Repository {

  final String _apiUrl;

  FixerRepository(this._apiUrl);

  @override
  Future getCurrencyData() async {
    return _loadFromNetwork();
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