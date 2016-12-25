import 'converter_contract.dart';
import 'dart:html';

class CurrencyConverterView implements ConverterView {

  Element _content;
  Element _error;
  Element _loading;

  CurrencyConverterView() {
    _content = querySelector("#content");
    _error = querySelector("#error");
    _loading = querySelector("#loading");
  }

  @override
  void swap() {
    //InputElement input = querySelector("#amount-from");
    //input.value = "123456";
  }

  @override
  void showContent() {
    _content.style.display = 'block';
    _error.style.display = 'none';
    _loading.style.display = 'none';
  }

  @override
  void showError(Exception e) {
    _content.style.display = 'none';
    _error.style.display = 'block';
    _loading.style.display = 'none';
  }

  @override
  void showLoading() {
    _content.style.display = 'none';
    _error.style.display = 'none';
    _loading.style.display = 'block';
  }
}