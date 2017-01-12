import 'dart:async';
import 'dart:html';
import 'overlay_options.dart';

import 'package:js/js.dart';

@JS("mui.overlay")
external Element overlay(String action, OverlayOptions options);

class SideDrawer {

  Element _sideDrawerEl;
  Element _showDrawer;
  Element _hideDrawer;

  Element get showDrawer => _showDrawer;
  Element get hideDrawer => _hideDrawer;

  SideDrawer() {
    this._sideDrawerEl = querySelector("#sidedrawer");
    this._showDrawer = querySelector('.js-show-sidedrawer');
    this._hideDrawer = querySelector('.js-hide-sidedrawer');
    this._showDrawer.onClick.listen(
            (event) => _showSideDrawer(event)
    );
    this._hideDrawer.onClick.listen(
            (event) => _hideSideDrawer(event)
    );
  }

  void _showSideDrawer(Event e) {

    OverlayOptions options = new OverlayOptions();
    options.onclose = allowInterop(() {
      _sideDrawerEl.classes.remove("active");
      document.body.append(_sideDrawerEl);
    });

    Element overlayEl = overlay("on", options);

    overlayEl.append(_sideDrawerEl);
    new Timer(new Duration(milliseconds: 20), () => _sideDrawerEl.classes.add("active"));
  }

  void _hideSideDrawer(Event e) {
    querySelector('body').classes.toggle("hide-sidedrawer");
  }
}