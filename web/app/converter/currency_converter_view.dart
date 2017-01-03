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

  UListElement _currencyFromList;
  UListElement _currencyToList;

  CurrencyConverterView() {
    _presenter = new CurrencyConverterPresenter(new FixerRepository(), this);
    this._content = querySelector("#content");
    this._error = querySelector("#error");
    this._loading = querySelector("#loading");
    this._currencyFromList = querySelector("#currency-from-list");
    this._currencyToList = querySelector("#currency-to-list");
    this.loadData();
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
    this._presenter.loadCurrencyData();
  }

  @override
  void setCurrencies(List<Currency> currencies) {
    currencies.forEach((currency) => _addCurrencyListElement(currency));
  }

  void _addCurrencyListElement(Currency currency) {
    LIElement listElement = new LIElement();
    listElement.text = currency.code;
    listElement.attributes['class'] = 'mdl-menu__item';
    listElement.attributes['data-val'] = currency.code;
    _currencyFromList.children.add(listElement);
    _currencyToList.children.add(listElement);
  }

  @override
  void swap() {
    // TODO: implement swap
  }
}