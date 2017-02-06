import 'online_check.dart';
import 'dart:js';

class OnlineCheckImpl implements OnlineCheck {

  @override
  bool isOnline() {
    JsObject nav = new JsObject.fromBrowserObject((new JsObject.fromBrowserObject(context['window']))["navigator"]);
    if (nav.hasProperty("onLine")) {
      return nav["onLine"];
    }
    return false;
  }
}