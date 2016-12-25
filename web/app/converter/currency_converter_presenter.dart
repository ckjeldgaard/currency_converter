import 'converter_contract.dart';

class CurrencyConverterPresenter implements ConverterUserActions {

  final ConverterView _view;

  CurrencyConverterPresenter(this._view);

  @override
  void loadCurrencyData() {
    this._view.showLoading();
    // TODO: implement loadCurrencyData
  }
  @override
  void doSwap() {
    this._view.swap();
  }
}