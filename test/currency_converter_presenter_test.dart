import '../web/app/converter/converter_contract.dart';
import '../web/app/converter/currency_converter_presenter.dart';
import "package:test/test.dart";
import 'package:mockito/mockito.dart';

class ConverterViewMock extends Mock implements ConverterView {}

void main() {
  test("Test load currency data", () {
    ConverterView viewMock = new ConverterViewMock();
    ConverterUserActions presenter = new CurrencyConverterPresenter(viewMock);
    presenter.loadCurrencyData();
    verify(viewMock.showLoading());
  });
}