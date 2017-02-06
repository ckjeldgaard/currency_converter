import '../model/currency.dart';
import 'converter_contract.dart';
import 'dart:html';

class CurrencyConverterView implements ConverterView {

  ConverterUserActions _presenter;

  Element _content;
  Element _error;
  Element _loading;
  Element _offlineWarning;

  SelectElement _currencyFromList;
  SelectElement _currencyToList;

  InputElement amountFrom;
  InputElement amountTo;

  ButtonElement _swapButton;

  CurrencyConverterView(this._presenter) {
    this._presenter.view = this;
    this._content = querySelector("#content");
    this._error = querySelector("#error");
    this._loading = querySelector("#loading");
    this._currencyFromList = querySelector("#currency-from");
    this._currencyToList = querySelector("#currency-to");
    this.amountFrom = querySelector("#amount-from");
    this.amountTo = querySelector("#amount-to");
    this._swapButton = querySelector("#swap-button");
    this._offlineWarning = querySelector("#offline-warning");

    this._handleOnlineCheck();
    this.loadData();
  }

  void _handleOnlineCheck() {
    this._presenter.checkOnline();
    new EventStreamProvider("online").forTarget(window).listen((e) {
      this.hideOfflineWarning();
      print("Now online. Loading data again...");
      this.loadData();
    });

    new EventStreamProvider("offline").forTarget(window).listen((e) {
      this.showOfflineWarning();
    });
  }

  SelectElement get currencyFromList => _currencyFromList;
  SelectElement get currencyToList => _currencyToList;

  @override
  void showContent() {
    _content.style.display = 'block';
    _error.style.display = 'none';
    _loading.style.display = 'none';
  }

  @override
  void showError(Exception e) {
    _content.style.display = 'none';
    _error.style.display = 'block';
    _loading.style.display = 'none';
  }

  @override
  void showLoading() {
    _content.style.display = 'none';
    _error.style.display = 'none';
    _loading.style.display = 'block';
  }

  @override
  void loadData() {
    this.amountFrom.onInput.listen((event) => _doConversion(event, amountFrom, amountTo, _currencyFromList, _currencyToList));
    this.amountTo.onInput.listen((event) => _doConversion(event, amountTo, amountFrom, _currencyToList, _currencyFromList));

    this._currencyFromList.onChange.listen((event) => _doConversion(event, amountFrom, amountTo, _currencyFromList, _currencyToList));
    this._currencyToList.onChange.listen((event) => _doConversion(event, amountFrom, amountTo, _currencyFromList, _currencyToList));

    this._swapButton.onClick.listen((event) {
      amountTo.value = this._presenter.swap(
          amountFrom.value,
          this._currencyFromList.selectedOptions[0].value,
          this._currencyToList.selectedOptions[0].value
      );
    });

    this._presenter.loadCurrencyData();
  }

  void _doConversion(KeyboardEvent event, InputElement thisAmount, InputElement otherAmount, SelectElement thisList, SelectElement otherList) {
    otherAmount.value = this._presenter.convert(thisAmount.value, thisList.selectedOptions[0].value, otherList.selectedOptions[0].value);
  }

  @override
  void setCurrencies(List<Currency> currencies) {
    _currencyFromList.children.clear();
    _currencyToList.children.clear();
    currencies.forEach((currency) => _addCurrencyListElement(_currencyFromList, currency));
    currencies.forEach((currency) => _addCurrencyListElement(_currencyToList, currency));
  }

  void _addCurrencyListElement(SelectElement list, Currency currency) {
    OptionElement option = new OptionElement();
    option.text = currency.code;
    option.value = currency.code;
    list.children.add(option);
  }

  @override
  void setSelectedFromCurrency(Currency currency) {
    for (OptionElement option in _currencyFromList.options) {
      if (currency.code == option.value) {
        option.selected = true;
      }
    }
  }

  @override
  void setSelectedToCurrency(Currency currency) {
    for (OptionElement option in _currencyToList.options) {
      if (currency.code == option.value) {
        option.selected = true;
      }
    }
  }

  @override
  void hideOfflineWarning() {
    this._offlineWarning.style.display = 'none';
  }

  @override
  void showOfflineWarning() {
    this._offlineWarning.style.display = 'block';
  }
}