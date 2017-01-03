import '../../web/app/converter/converter_contract.dart';
import '../../web/app/converter/currency_converter_presenter.dart';
import '../../web/app/data/repository.dart';
import '../../web/app/model/currency.dart';
import 'dart:async';
import "package:test/test.dart";
import 'package:mockito/mockito.dart';

class ConverterViewMock extends Mock implements ConverterView {}
class RepositoryMock extends Mock implements Repository {}

void main() {
  ConverterView viewMock = new ConverterViewMock();
  Repository repositoryMock = new RepositoryMock();

  test("Test load currency data", () {

    List<Currency> currencies = new List();
    currencies.add(new Currency("x", 1.1));

    Future future = new Future.value(currencies);

    when(repositoryMock.getCurrencyData()).thenReturn(future);

    ConverterUserActions presenter = new CurrencyConverterPresenter(repositoryMock, viewMock);
    presenter.loadCurrencyData();

    verify(viewMock.showLoading());

    // Verify the callback is invoked on the next event loop.
    new Future(expectAsync0(() {
      verify(viewMock.showContent()).called(1);
      verify(viewMock.setCurrencies(currencies));
    }));
  });

  test("Test currency conversion", () {
    ConverterUserActions presenter = new CurrencyConverterPresenter(repositoryMock, viewMock);
    Currency currencyFrom = new Currency("EUR", 1.0);
    Currency currencyTo = new Currency("USD", 1.0465);

    expect(
        presenter.convert(currencyFrom, currencyTo, 100.0),
        equals(104.65)
    );
  });
}