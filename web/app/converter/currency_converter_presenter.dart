import '../data/repository.dart';
import '../model/currency.dart';
import 'converter_contract.dart';

class CurrencyConverterPresenter implements ConverterUserActions, LoadCurrenciesCallback {

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
    this._view.showContent();
  }

  @override
  void onFailure(Exception ex) {
    this._view.showError(ex);
  }

}