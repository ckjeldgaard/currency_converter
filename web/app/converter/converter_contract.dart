abstract class ConverterView {
  void showLoading();
  void showContent();
  void showError(Exception e);
  void loadData();
  void swap();
}

abstract class ConverterUserActions {
  void loadCurrencyData();
  void doSwap();
}