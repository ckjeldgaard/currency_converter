import 'package:js/js.dart';

@JS()
@anonymous
class OverlayOptions {
  external Function get onclose;
  external set onclose(Function function);
}