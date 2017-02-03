import "dart:js" as js;

class JsOptions {

  final Map _options;

  JsOptions(this._options);

  js.JsObject toJsObject() {
    var result = new Map();
    this._options.forEach((key, value) {
      if (value != null) {
        result[key] = value;
      }
    });
    return new js.JsObject.jsify(result);
  }
}