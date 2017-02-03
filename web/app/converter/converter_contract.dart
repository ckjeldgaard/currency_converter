import '../model/currency.dart';

abstract class ConverterView {
  void showLoading();
  void showContent();
  void showError(Exception e);
  void loadData();
  void setCurrencies(List<Currency> currencies);
  void swap();
  void setSelectedFromCurrency(Currency currency);
  void setSelectedToCurrency(Currency currency);
}

abstract class ConverterUserActions {
  set view(ConverterView value);
  void loadCurrencyData();
  String convert(String amount, String codeFrom, String codeTo);
}