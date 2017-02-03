import 'dart:js';

class OnlineCheck {

  bool isOnline() {
    JsObject nav = new JsObject.fromBrowserObject((new JsObject.fromBrowserObject(context['window']))["navigator"]);
    if (nav.hasProperty("onLine")) {
      return nav["onLine"];
    }
    return false;
  }

}