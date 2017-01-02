class Currency {
  final String _code;
  final double _rate;

  Currency(this._code, this._rate);

  String get code => _code;

  double get rate => _rate;
}