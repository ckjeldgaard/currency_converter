import 'currency.dart';
import 'dart:collection';

abstract class Currencies extends Object with IterableMixin<Currency> {
  Currency add(String code, double rate);
}
