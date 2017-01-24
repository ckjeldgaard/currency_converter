import 'currency.dart';

class DefaultCurrency implements Currency {
  final String _code;
  final double _rate;

  DefaultCurrency(this._code, this._rate);

  @override
  String get code => _code;

  @override
  double get rate => _rate;

  @override
  double convertAmountTo(double amount, Currency other) {
    return other.rate / this._rate * amount;
  }

  @override
  int compareTo(Currency other) {
    return this._code.compareTo(other.code);
  }

  @override
  void save() {
    // TODO: implement save
  }
}