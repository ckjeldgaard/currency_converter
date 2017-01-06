import 'app/converter/converter_contract.dart';
import 'app/converter/currency_converter_view.dart';
import 'dart:async';
import 'dart:html';
import 'package:js/js.dart';

@JS("mui.overlay")
external Element overlay(String action, OverlayOptions options);

@JS()
@anonymous
class OverlayOptions {
  external Function get onclose;
  external set onclose(Function function);

  external factory OverlayOptions({
    Function onclose
  });
}

void main() {
  ConverterView view = new CurrencyConverterView();

  querySelector('.js-show-sidedrawer').onClick.listen(
          (event) => showSideDrawer(event)
  );
  querySelector('.js-hide-sidedrawer').onClick.listen(
          (event) => hideSideDrawer(event)
  );
}

void showSideDrawer(Event e) {
  var sideDrawerEl = querySelector("#sidedrawer");

  // show overlay
  OverlayOptions options = new OverlayOptions(onclose: allowInterop(() {
    sideDrawerEl.classes.remove("active");
    document.body.append(sideDrawerEl);
  }));

  Element overlayEl = overlay("on", options);

  print(overlayEl);
  overlayEl.append(sideDrawerEl);
  new Timer(new Duration(milliseconds: 20), () => sideDrawerEl.classes.add("active"));
}

void hideSideDrawer(Event e) {
  querySelector('body').classes.toggle("hide-sidedrawer");
}