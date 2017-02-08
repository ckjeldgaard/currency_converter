import '../model/currency.dart';
import 'dart:async';

abstract class LoadCurrenciesCallback {
  void onCurrenciesLoaded(List<Currency> currencies);
  void onFailure(Exception ex);
}

abstract class Repository {
  Future getCurrencyData();
  int getTimestamp();
}