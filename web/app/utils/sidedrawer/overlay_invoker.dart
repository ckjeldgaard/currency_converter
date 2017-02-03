import 'dart:html';
import 'overlay.dart';
import 'overlay_options.dart';
import 'package:js/js.dart';

@JS("mui.overlay")
external Element overlay(String action, OverlayOptions options);

class OverlayInvoker implements Overlay {

  @override
  Element invokeOverlay(String action, OverlayOptions options) {
    return overlay("on", options);
  }
}