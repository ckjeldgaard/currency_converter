@TestOn("content-shell")

import 'dart:html';
import "package:test/test.dart";
import '../web/app/converter/currency_converter_view.dart';

void main() {
  CurrencyConverterView view = new CurrencyConverterView();

  test("Test show content", () {
    view.showContent();
    expect(querySelector("#content").style.display, equals("block"));
    expect(querySelector("#error").style.display, equals("none"));
    expect(querySelector("#loading").style.display, equals("none"));
  });
}