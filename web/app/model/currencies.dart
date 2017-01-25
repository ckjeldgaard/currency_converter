import 'currency.dart';

abstract class Currencies {
  void add(Currency currency);
  void addAll(List<Currency> currencies);
  getCurrencies();
}
