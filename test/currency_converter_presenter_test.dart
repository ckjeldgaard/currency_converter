import '../web/app/converter/converter_contract.dart';
import '../web/app/converter/currency_converter_presenter.dart';
import '../web/app/data/repository.dart';
import "package:test/test.dart";
import 'package:mockito/mockito.dart';

class ConverterViewMock extends Mock implements ConverterView {}
class RepositoryMock extends Mock implements Repository {}

void main() {
  test("Test load currency data", () {
    ConverterView viewMock = new ConverterViewMock();
    Repository repository = new RepositoryMock();
    ConverterUserActions presenter = new CurrencyConverterPresenter(repository, viewMock);
    presenter.loadCurrencyData();
    verify(viewMock.showLoading());
  });
}