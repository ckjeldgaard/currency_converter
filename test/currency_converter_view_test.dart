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

  test("Test show loading", () {
    view.showLoading();
    expect(querySelector("#content").style.display, equals("none"));
    expect(querySelector("#error").style.display, equals("none"));
    expect(querySelector("#loading").style.display, equals("block"));
  });

  test("Test show error", () {
    view.showError(new Exception());
    expect(querySelector("#content").style.display, equals("none"));
    expect(querySelector("#error").style.display, equals("block"));
    expect(querySelector("#loading").style.display, equals("none"));
  });
}