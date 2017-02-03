@TestOn("content-shell")

import '../../web/app/converter/converter_contract.dart';
import '../../web/app/model/currency.dart';
import '../../web/app/model/default_currency.dart';
import 'dart:html';
import 'package:mockito/mockito.dart';
import "package:test/test.dart";
import '../../web/app/converter/currency_converter_view.dart';

class CurrencyConverterPresenterMock extends Mock implements ConverterUserActions {}

void main() {
  CurrencyConverterView view = new CurrencyConverterView(new CurrencyConverterPresenterMock());

  List<Currency> currenciesList = new List<Currency>();
  currenciesList.add(new DefaultCurrency("EUR", 1.0));
  currenciesList.add(new DefaultCurrency("USD", 2.0));

  test("Test show content", () {
    view.showContent();
    expect(querySelector("#content").style.display, equals("block"));
    expect(querySelector("#error").style.display, equals("none"));
    expect(querySelector("#loading").style.display, equals("none"));
  });

  test("Test show loading", () {
    view.showLoading();
    expect(querySelector("#content").style.display, equals("none"));
    expect(querySelector("#error").style.display, equals("none"));
    expect(querySelector("#loading").style.display, equals("block"));
  });

  test("Test show error", () {
    view.showError(new Exception());
    expect(querySelector("#content").style.display, equals("none"));
    expect(querySelector("#error").style.display, equals("block"));
    expect(querySelector("#loading").style.display, equals("none"));
  });

  test("Test set currencies", () {
    CurrencyConverterView currencyView = new CurrencyConverterView(new CurrencyConverterPresenterMock());
    currencyView.setCurrencies(currenciesList);

    expect(currencyView.currencyFromList.children[0].text, equals(currenciesList[0].code));
    expect(currencyView.currencyFromList.children[1].text, equals(currenciesList[1].code));
  });

  test("Test setting selected from currency", () {
    CurrencyConverterView v = new CurrencyConverterView(new CurrencyConverterPresenterMock());
    v.setSelectedFromCurrency(currenciesList[1]);
    expect(v.currencyFromList.selectedOptions[0].value, equals(currenciesList[1].code));
  });

  test("Test setting selected to currency", () {
    CurrencyConverterView currencyView = new CurrencyConverterView(new CurrencyConverterPresenterMock());
    currencyView.setSelectedToCurrency(currenciesList[1]);
    expect(currencyView.currencyFromList.selectedOptions[0].value, equals(currenciesList[1].code));
  });

  test("Test currency conversion", () {

    CurrencyConverterPresenterMock mockPresenter = new CurrencyConverterPresenterMock();
    when(mockPresenter.convert(any, any, any)).thenReturn("200");

    CurrencyConverterView currencyView = new CurrencyConverterView(mockPresenter);
    currencyView.setCurrencies(currenciesList);
    currencyView.setSelectedFromCurrency(currenciesList[0]);
    currencyView.setSelectedToCurrency(currenciesList[1]);

    currencyView.amountFrom.value = "100";
    currencyView.amountFrom.dispatchEvent(new KeyboardEvent("input"));

    expect(currencyView.amountTo.value, equals("200"));
    verify(mockPresenter.convert("100", currenciesList[0].code, currenciesList[1].code));
  });
}