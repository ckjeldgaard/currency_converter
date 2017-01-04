import '../model/currency.dart';
import '../model/default_currency.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'repository.dart';

class FixerRepository implements Repository {

  final String _URL = "http://api.fixer.io/latest";

  @override
  Future getCurrencyData() async {
    try {
      String dataResponse = await HttpRequest.getString(_URL);
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