import '../../web/app/data/repository.dart';
import '../../web/app/model/currency.dart';
import 'dart:async';

class MockRepository implements Repository {

  @override
  Future getCurrencyData() {
    List<Currency> currencies = new List();
    return new Future.value(currencies);
  }
}