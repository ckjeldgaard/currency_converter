import '../data/repository.dart';
import '../model/currency.dart';
import '../utils/online_check.dart';
import 'converter_contract.dart';

class CurrencyConverterPresenter implements ConverterUserActions, LoadCurrenciesCallback {

  final String _DEFAULT_FROM_CURRENCY = "EUR";
  final String _DEFAULT_TO_CURRENCY = "USD";

  final Repository _repository;
  ConverterView _view;
  List<Currency> loadedCurrencies = new List<Currency>();

  CurrencyConverterPresenter(this._repository);

  @override
  set view(ConverterView view) {
    this._view = view;
  }

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
    double amountToConvert;
    try {
      if (amount.isNotEmpty && loadedCurrencies.isNotEmpty) {
        amountToConvert = double.parse(amount);
        convertedAmount = this._getCurrency(codeFrom).convertAmountTo(amountToConvert, this._getCurrency(codeTo)).toStringAsFixed(2);
      }
    } catch (e) {
      throw new FormatException("Could not parse amount to convert", e);
    }
    return convertedAmount;
  }

  @override
  void onCurrenciesLoaded(List<Currency> currencies) {
    this.loadedCurrencies = currencies;
    this._view.setCurrencies(loadedCurrencies);
    this._view.setSelectedFromCurrency(_getCurrency(_DEFAULT_FROM_CURRENCY));
    this._view.setSelectedToCurrency(_getCurrency(_DEFAULT_TO_CURRENCY));
    this._view.showContent();
  }

  Currency _getCurrency(String code) {
    for (Currency c in loadedCurrencies) {
      if (c.code == code) {
        return c;
      }
    }
    return loadedCurrencies[0];
  }

  @override
  void onFailure(Exception ex) {
    this._view.showError(ex);
  }

  @override
  void checkOnline() {
    if (new OnlineCheck().isOnline()) {
      this._view.hideOfflineWarning();
    } else {
      this._view.showOfflineWarning();
    }
  }
}