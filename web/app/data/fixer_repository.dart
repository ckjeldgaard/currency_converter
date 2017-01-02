import '../model/currency.dart';
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
      return parseJsonData(dataResponse);
    } catch (e) {
      throw e;
    }
  }

  List<Currency> parseJsonData(String dataResponse) {
    List<Currency> currencies = new List();
    Map json = JSON.decode(dataResponse);
    json["rates"].forEach((code, rate) => currencies.add(new Currency(code, rate)));
    return currencies;
  }

}