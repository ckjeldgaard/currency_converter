import '../data/repository.dart';
import '../model/currency.dart';
import 'converter_contract.dart';

class CurrencyConverterPresenter implements ConverterUserActions, LoadCurrenciesCallback {

  final String _DEFAULT_FROM_CURRENCY = "EUR";
  final String _DEFAULT_TO_CURRENCY = "USD";

  final Repository _repository;
  final ConverterView _view;

  CurrencyConverterPresenter(this._repository, this._view);

  @override
  void loadCurrencyData() {
    this._view.showLoading();
    this._repository.getCurrencyData()
      .then(onCurrenciesLoaded)
      .catchError((e) => onFailure(e));
  }

  @override
  void onCurrenciesLoaded(List<Currency> currencies) {
    this._view.setCurrencies(currencies);
    this._view.setSelectedFromCurrency(_getCurrency(currencies, _DEFAULT_FROM_CURRENCY));
    this._view.setToCurrency(_getCurrency(currencies, _DEFAULT_TO_CURRENCY));
    this._view.showContent();
  }

  Currency _getCurrency(List<Currency> currencies, String code) {
    for (Currency c in currencies) {
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