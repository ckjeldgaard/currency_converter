import '../model/currency.dart';

abstract class ConverterView {
  void showLoading();
  void showContent();
  void showError(Exception e);
  void loadData();
  void setCurrencies(List<Currency> currencies);
  void setSelectedFromCurrency(Currency currency);
  void setSelectedToCurrency(Currency currency);
  void showOfflineWarning();
  void hideOfflineWarning();
  void setLastUpdated(String text);
}

abstract class ConverterUserActions {
  set view(ConverterView value);
  void loadCurrencyData();
  String convert(String amount, String codeFrom, String codeTo);
  void checkOnline();
  String swap(String amount, String codeFrom, String codeTo);
}