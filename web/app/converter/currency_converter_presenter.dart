import '../data/repository.dart';
import '../model/currency.dart';
import '../utils/online_check.dart';
import 'converter_contract.dart';

class CurrencyConverterPresenter implements ConverterUserActions, LoadCurrenciesCallback {

  final String _DEFAULT_FROM_CURRENCY = "EUR";
  final String _DEFAULT_TO_CURRENCY = "USD";

  final Repository _repository;
  final OnlineCheck _onlineCheck;
  ConverterView _view;
  List<Currency> loadedCurrencies = new List<Currency>();

  CurrencyConverterPresenter(this._repository, this._onlineCheck);

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

    if (this._repository.getTimestamp() > 0) {
      DateTime lastUpdate = new DateTime.fromMillisecondsSinceEpoch(this._repository.getTimestamp());
      String dateFormatted = lastUpdate.year.toString() + "-" + lastUpdate.month.toString().padLeft(2, '0') + "-" + lastUpdate.day.toString().padLeft(2, '0');
      this._view.setLastUpdated("Currencies last updated on " + dateFormatted);
    }
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
    if (this._onlineCheck.isOnline()) {
      this._view.hideOfflineWarning();
    } else {
      this._view.showOfflineWarning();
    }
  }

  @override
  String swap(String amount, String codeFrom, String codeTo) {
    this._view.setSelectedFromCurrency(_getCurrency(codeTo));
    this._view.setSelectedToCurrency(_getCurrency(codeFrom));

    if (amount.isNotEmpty) {
      return this.convert(amount, codeTo, codeFrom);
    }
    return "";
  }
}