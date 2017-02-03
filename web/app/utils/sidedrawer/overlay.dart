import 'dart:html';
import 'overlay_options.dart';

abstract class Overlay {
  Element invokeOverlay(String action, OverlayOptions options);
}