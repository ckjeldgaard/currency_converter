import '../../web/app/model/currency.dart';
import '../../web/app/model/default_currency.dart';
import 'package:test/test.dart';

void main() {
  test("Test amount conversion", () {
    Currency currencyFrom = new DefaultCurrency("EUR", 1.0);
    Currency currencyTo = new DefaultCurrency("USD", 1.0465);

    expect(
      currencyFrom.convertAmountTo(100.0, currencyTo),
        equals(104.65)
    );
  });
}