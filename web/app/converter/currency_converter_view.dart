import '../data/fixer_repository.dart';
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
    _presenter = new CurrencyConverterPresenter(new FixerRepository(), this);
    this._content = querySelector("#content");
    this._error = querySelector("#error");
    this._loading = querySelector("#loading");
    this._currencyFromList = querySelector("#currency-from");
    this._currencyToList = querySelector("#currency-to");
    this.amountFrom = querySelector("#amount-from");
    this.amountTo = querySelector("#amount-to");
    this.loadData();
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

    this._currencyFromList.onChange.listen((event) => _doConversion(event, amountTo, amountFrom, _currencyToList, _currencyFromList));
    this._currencyToList.onChange.listen((event) => _doConversion(event, amountFrom, amountTo, _currencyFromList, _currencyToList));

    this._presenter.loadCurrencyData();
  }

  void _doConversion(KeyboardEvent event, InputElement thisAmount, InputElement otherAmount, SelectElement thisList, SelectElement otherList) {
    otherAmount.value = this._presenter.convert(thisAmount.value, thisList.selectedOptions[0].value, otherList.selectedOptions[0].value);
  }

  @override
  void setCurrencies(List<Currency> currencies) {
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
  void swap() {
    // TODO: implement swap
  }

}