import '../model/currency.dart';
import 'converter_contract.dart';
import 'currency_converter_presenter.dart';
import 'dart:html';

class CurrencyConverterView implements ConverterView {

  ConverterUserActions _presenter;

  Element _content;
  Element _error;
  Element _loading;

  SelectElement _currencyFromList;
  SelectElement _currencyToList;

  InputElement amountFrom;
  InputElement amountTo;

  CurrencyConverterView() {
    //_presenter = new CurrencyConverterPresenter(null, this);
    this._content = querySelector("#content");
    this._error = querySelector("#error");
    this._loading = querySelector("#loading");
    this._currencyFromList = querySelector("#currency-from");
    this._currencyToList = querySelector("#currency-to");
    this.amountFrom = querySelector("#amount-from");
    this.amountTo = querySelector("#amount-to");
    //this.loadData();
  }

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
    this.amountFrom.onKeyUp.listen((event) => doConversion(event));

    this._presenter.loadCurrencyData();
  }

  void doConversion(KeyboardEvent event) {
    print(amountFrom.value);
  }

  @override
  void setCurrencies(List<Currency> currencies) {
    currencies.forEach((currency) => _addCurrencyListElement(_currencyFromList, currency));
    currencies.forEach((currency) => _addCurrencyListElement(_currencyToList, currency));
  }

  void _addCurrencyListElement(SelectElement list, Currency currency) {
    OptionElement option = new OptionElement();
    option.text = currency.code;
    list.children.add(option);
  }

  @override
  void swap() {
    // TODO: implement swap
  }
}