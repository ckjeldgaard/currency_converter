import '../data/repository.dart';
import '../model/currency.dart';
import 'converter_contract.dart';
import 'dart:math';

class CurrencyConverterPresenter implements ConverterUserActions, LoadCurrenciesCallback {

  final String _DEFAULT_FROM_CURRENCY = "EUR";
  final String _DEFAULT_TO_CURRENCY = "USD";

  final Repository _repository;
  final ConverterView _view;
  List<Currency> _currencies;

  CurrencyConverterPresenter(this._repository, this._view);

  @override
  void loadCurrencyData() {
    this._view.showLoading();
    this._repository.getCurrencyData()
      .then(onCurrenciesLoaded)
      .catchError((e) => onFailure(e));
  }

  @override
  String convert(String amount, String codeFrom, String codeTo) {
    String convertedAmount = "";
    if (amount.isNotEmpty && _currencies.isNotEmpty && double.parse(amount) is double) {
      convertedAmount = this._getCurrency(codeFrom).convertAmountTo(double.parse(amount), this._getCurrency(codeTo)).toStringAsFixed(2);
    }
    return convertedAmount;
  }

  @override
  void onCurrenciesLoaded(List<Currency> currencies) {
    this._currencies = currencies;
    this._view.setCurrencies(_currencies);
    this._view.setSelectedFromCurrency(_getCurrency(_DEFAULT_FROM_CURRENCY));
    this._view.setSelectedToCurrency(_getCurrency(_DEFAULT_TO_CURRENCY));
    this._view.showContent();
  }

  Currency _getCurrency(String code) {
    for (Currency c in _currencies) {
      if (c.code == code) {
        return c;
      }
    }
    return null;
  }

  @override
  void onFailure(Exception ex) {
    this._view.showError(ex);
  }
}