import '../model/currency.dart';

abstract class ConverterView {
  void showLoading();
  void showContent();
  void showError(Exception e);
  void loadData();
  void setCurrencies(List<Currency> currencies);
  void swap();
}

abstract class ConverterUserActions {
  void loadCurrencyData();
}