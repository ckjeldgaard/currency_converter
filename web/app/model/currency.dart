abstract class Currency {
  String get code;
  double get rate;
  double convertAmountTo(double amount, Currency other);
  int compareTo(Currency other);
  void save();
}