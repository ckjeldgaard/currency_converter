import 'currency.dart';

class CurrenciesIterator implements Iterator<Currency> {

  final List<Currency> _currencies;
  int _index;

  CurrenciesIterator(this._currencies) {
    this._index = -1;
  }

  @override
  Currency get current => _currencies[_index];

  @override
  bool moveNext() {
    while (++_index < _currencies.length) {
      return true;
    }
    return false;
  }
}