@TestOn("vm")

import '../../web/app/converter/converter_contract.dart';
import '../../web/app/converter/currency_converter_presenter.dart';
import '../../web/app/data/repository.dart';
import '../../web/app/model/currency.dart';
import '../../web/app/model/default_currency.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:mockito/mockito.dart';

class ConverterViewMock extends Mock implements ConverterView {}
class RepositoryMock extends Mock implements Repository {}

void main() {
  ConverterView viewMock = new ConverterViewMock();
  Repository repositoryMock = new RepositoryMock();

  Currency currencyFrom = new DefaultCurrency("EUR", 1.0);
  Currency currencyTo = new DefaultCurrency("TST", 2.0);

  List<Currency> currencies = new List<Currency>();
  currencies.add(currencyFrom);
  currencies.add(currencyTo);

  test("Test load currency data", () {

    List<Currency> currencies = new List();
    currencies.add(new DefaultCurrency("x", 1.1));

    Future future = new Future.value(currencies);

    when(repositoryMock.getCurrencyData()).thenReturn(future);

    ConverterUserActions presenter = new CurrencyConverterPresenter(repositoryMock, viewMock);
    presenter.loadCurrencyData();

    verify(viewMock.showLoading());

    // Verify the callback is invoked on the next event loop.
    new Future(expectAsync0(() {
      verify(viewMock.showContent()).called(1);
      verify(viewMock.setCurrencies(currencies));
      verify(viewMock.setSelectedFromCurrency(any));
      verify(viewMock.setSelectedToCurrency(any));
    }));
  });

  test("Test presenter conversion", () {
    CurrencyConverterPresenter presenter = new CurrencyConverterPresenter(repositoryMock, viewMock);
    presenter.loadedCurrencies = currencies;

    expect(
        presenter.convert("100", currencyFrom.code, currencyTo.code),
        equals("200.00")
    );
  });

  test("Test presenter conversion without loaded currencies", () {
    CurrencyConverterPresenter presenter = new CurrencyConverterPresenter(repositoryMock, viewMock);
    expect(
        presenter.convert("100", currencyFrom.code, currencyTo.code),
        isEmpty
    );
  });

  /* test("Test presenter conversion with invalid amount", () {
    CurrencyConverterPresenter presenter = new CurrencyConverterPresenter(repositoryMock, viewMock);
    presenter.loadedCurrencies = currencies;
    expect(
        presenter.convert("100x", "", ""),
        throwsA(new isInstanceOf<FormatException>())
    );
  }); */

  test("Test presenter conversion with empty amount", () {
    CurrencyConverterPresenter presenter = new CurrencyConverterPresenter(repositoryMock, viewMock);
    presenter.loadedCurrencies = currencies;
    expect(
        presenter.convert("", currencyFrom.code, currencyTo.code),
        isEmpty
    );
  });

}