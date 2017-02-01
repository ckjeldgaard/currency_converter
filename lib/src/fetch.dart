library FetchAPI;

import 'dart:async';
import 'dart:typed_data';
import 'dart:js';
import 'dart:convert';

import 'util.dart';

abstract class HttpStatus {
  static const int CONTINUE = 100;
  static const int SWITCHING_PROTOCOLS = 101;
  static const int OK = 200;
  static const int CREATED = 201;
  static const int ACCEPTED = 202;
  static const int NON_AUTHORITATIVE_INFORMATION = 203;
  static const int NO_CONTENT = 204;
  static const int RESET_CONTENT = 205;
  static const int PARTIAL_CONTENT = 206;
  static const int MULTIPLE_CHOICES = 300;
  static const int MOVED_PERMANENTLY = 301;
  static const int FOUND = 302;
  static const int MOVED_TEMPORARILY = 302; // Common alias for FOUND.
  static const int SEE_OTHER = 303;
  static const int NOT_MODIFIED = 304;
  static const int USE_PROXY = 305;
  static const int TEMPORARY_REDIRECT = 307;
  static const int BAD_REQUEST = 400;
  static const int UNAUTHORIZED = 401;
  static const int PAYMENT_REQUIRED = 402;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;
  static const int METHOD_NOT_ALLOWED = 405;
  static const int NOT_ACCEPTABLE = 406;
  static const int PROXY_AUTHENTICATION_REQUIRED = 407;
  static const int REQUEST_TIMEOUT = 408;
  static const int CONFLICT = 409;
  static const int GONE = 410;
  static const int LENGTH_REQUIRED = 411;
  static const int PRECONDITION_FAILED = 412;
  static const int REQUEST_ENTITY_TOO_LARGE = 413;
  static const int REQUEST_URI_TOO_LONG = 414;
  static const int UNSUPPORTED_MEDIA_TYPE = 415;
  static const int REQUESTED_RANGE_NOT_SATISFIABLE = 416;
  static const int EXPECTATION_FAILED = 417;
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int NOT_IMPLEMENTED = 501;
  static const int BAD_GATEWAY = 502;
  static const int SERVICE_UNAVAILABLE = 503;
  static const int GATEWAY_TIMEOUT = 504;
  static const int HTTP_VERSION_NOT_SUPPORTED = 505;
  // Client generated status code.
  static const int NETWORK_CONNECT_TIMEOUT_ERROR = 599;
}

enum ResponseType { BASIC, CORS, ERROR, OPAQUE }

enum RequestMethod { GET, POST }

enum RequestMode { CORS, NO_CORS, SAME_ORIGIN, NAVIGATE }

enum RequestCredentials { OMIT, SAME_ORIGIN, INCLUDE }

enum CacheMode { DEFAULT, NO_STORE, RELOAD, NO_CACHE, FORCE_CACHE }

enum RedirectMode { FOLLOW, ERROR, MANUAL }

class Headers implements JsProxyObject {
  /// Creates a new Headers object.
  Headers() {
    _internal = new JsObject(context["Headers"]);
  }

  /// Creates a new Headers object from an existing [Headers] object.

  Headers.withHeaders(Headers headers) {
    _internal = new JsObject(context["Headers"], [headers._internal]);
  }

  /// Creates a new Headers object and populate them with key/value pairs
  /// from the given [Map].

  Headers.withMap(Map headers) {
    _internal = new JsObject(context["Headers"], [headers]);
  }

  Headers.internal(this._internal) {}

  /// Appends a new value onto an existing header inside a Headers object,
  /// or adds the header if it does not already exist.

  void append(String name, String value) {
    _internal.callMethod("append", [name, value]);
  }

  void delete(String name) {
    _internal.callMethod("delete", [name]);
  }

  Map<String, String> entries() {
    var entries = {};
    JsArray it = _internal.callMethod("entries");
    for (JsArray pair in it) {
      entries[pair.elementAt(0)] = pair.elementAt(1);
    }
    return entries;
  }

  String getHeader(String name) {
    return _internal.callMethod("get", [name]);
  }

  List<String> getAll(String name) {
    return (_internal.callMethod("get", [name]) as JsArray)
        .toList(growable: false);
  }

  bool has(String name) {
    return _internal.callMethod("has", [name]);
  }

  List<String> keys() {
    return (_internal.callMethod("keys") as JsArray).toList(growable: false);
  }

  void setHeader(String name, String value) {
    _internal.callMethod("set", [name, value]);
  }

  List<String> values() {
    return (_internal.callMethod("values") as JsArray).toList(growable: false);
  }

  JsObject toJs() => _internal;

  JsObject _internal;
}

class Response implements JsProxyObject {
  Response(
      {String strData,
      Uint8List byteData,
      int status: HttpStatus.OK,
      String statusText,
      Headers headers}) {
    var options = {"status": status};
    var body;
    if (strData != null) body = strData;
    if (byteData != null) {
      JsObject data = new JsObject.fromBrowserObject(byteData);
      body = new JsObject(context["Blob"], [data["buffer"]]);
    }
    if (statusText != null) options["statusText"] = statusText;
    if (headers != null) options["headers"] = headers.toJs();
    var args = [];
    if (body != null) args.add(body);
    args.add(new JsObject.jsify(options));
    _internal = new JsObject(context["Response"], args);
  }

  Response.internal(this._internal) {}

  /// Takes a [Response] stream and reads it to completion.
  /// It returns a [Future] that resolves with an [Uint8List].

  Future<Uint8List> data() async {
    Completer c = new Completer();
    JsObject promise = _internal.callMethod("arrayBuffer", []);
    promise.callMethod("then", [
      (buffer) {
        var data = new Uint8List.view(buffer);
        c.complete(data);
      }
    ]);
    return await c.future;
  }

  /// Takes a [Response] stream and reads it to completion.
  /// It returns a [Future] that resolves with a JSON decoded [Map].

  Future<Map> json() async {
    Completer c = new Completer();
    JsObject promise = _internal.callMethod("json", []);
    promise.callMethod("then", [
      (buffer) {
        var data = new JsonDecoder().convert(buffer);
        c.complete(data);
      }
    ]);
    return await c.future;
  }

  /// Takes a [Response] stream and reads it to completion.
  /// It returns a [Future] that resolves with a [String] (text).

  Future<String> text() async {
    Completer c = new Completer();
    JsObject promise = _internal.callMethod("text", []);
    promise.callMethod("then", [
      (buffer) {
        c.complete(buffer as String);
      }
    ]);
    return await c.future;
  }

  /// Creates a clone of a [Response] object.

  Response clone() => new Response.internal(_internal.callMethod("clone"));

  /// Returns a new [Response] object associated with a network error.

  Response error() => new Response.internal(_internal.callMethod("error"));

  /// Creates a new response with a different URL.

  Response redirect() =>
      new Response.internal(_internal.callMethod("redirect"));

  /// Contains the [Headers] object associated with the response.

  Headers get headers => new Headers.internal(_internal["headers"]);

  /// Contains a boolean stating whether the response was successful
  /// (status in the range 200-299) or not.

  bool get ok => _internal["ok"];

  /// Indicates whether or not the response is the result of a redirect;
  /// that is, its URL list has more than one entry.

  bool get redirected => _internal["redirected"];

  /// Contains the status code of the response (e.g., 200 for a success).

  int get status => _internal["status"];

  /// Contains the URL of the response.

  String get url => _internal["url"];

  /// Contains a boolean stating whether this is the final URL of the response.

  bool get useFinalURL => _internal["useFinalURL"];

  /// Contains the type of the response (e.g., basic, cors).

  ResponseType get type {
    switch (_internal["type"]) {
      case "basic":
        return ResponseType.BASIC;
      case "cors":
        return ResponseType.CORS;
      case "error":
        return ResponseType.ERROR;
      case "opaque":
        return ResponseType.OPAQUE;
      default:
        return ResponseType.BASIC;
    }
  }

  JsObject toJs() => _internal;

  JsObject _internal;
}

class Request implements JsProxyObject {
  Request(String url,
      {RequestMethod method,
      Headers headers,
      body,
      RequestMode mode,
      RequestCredentials credentials,
      CacheMode cache,
      RedirectMode redirect,
      String referrer,
      String integrity}) {
    var options = {};
    if (method != null) {
      if (method == RequestMethod.GET)
        options["method"] = "GET";
      else if (mode == RequestMethod.POST) options["method"] = "POST";
    }
    if (headers != null) options["headers"] = headers._internal;
    if (body != null) options["body"] = body;
    if (mode != null) {
      if (mode == RequestMode.CORS)
        options["mode"] = "cors";
      else if (mode == RequestMode.NO_CORS)
        options["mode"] = "no-cors";
      else if (mode == RequestMode.SAME_ORIGIN)
        options["mode"] = "same-origin";
      else if (mode == RequestMode.NAVIGATE) options["mode"] = "navigate";
    }
    if (credentials != null) {
      if (credentials == RequestCredentials.OMIT)
        options["credentials"] = "omit";
      else if (credentials == RequestCredentials.SAME_ORIGIN)
        options["credentials"] = "same-origin";
      else if (credentials == RequestCredentials.INCLUDE)
        options["credentials"] = "include";
    }
    if (cache != null) {
      if (cache == CacheMode.DEFAULT)
        options["cache"] = "default";
      else if (cache == CacheMode.NO_STORE)
        options["cache"] = "same-origin";
      else if (cache == CacheMode.RELOAD)
        options["cache"] = "reload";
      else if (cache == CacheMode.NO_CACHE)
        options["cache"] = "no-cache";
      else if (cache == CacheMode.FORCE_CACHE) options["cache"] = "force-cache";
    }
    if (redirect != null) {
      if (redirect == RedirectMode.FOLLOW)
        options["redirect"] = "default";
      else if (redirect == RedirectMode.ERROR)
        options["redirect"] = "error";
      else if (redirect == RedirectMode.MANUAL) options["redirect"] = "manual";
    }
    if (referrer != null) options["referrer"] = referrer;
    if (integrity != null) options["integrity"] = integrity;
    JsObject jsoptions = new JsObject.jsify(options);
    _internal = new JsObject(context["Request"], [url, jsoptions]);
  }

  Request.fromRequest(Request request) {
    _internal = new JsObject(context["Request"], [request._internal]);
  }

  Request.fromInternal(this._internal) {}

  /// Contains the request's method (GET, POST, etc.)

  RequestMethod get method {
    String m = _internal["method"];
    if (m == "GET") return RequestMethod.GET;
    return RequestMethod.POST;
  }

  /// Contains the URL of the request.

  String get url => _internal["url"];

  /// Contains the associated [Headers] object of the request.

  Headers get headers => new Headers.internal(_internal["headers"]);

  /// Contains the referrer of the request (e.g., client).

  String get referrer => _internal["referrer"];

  /// Contains the referrer policy of the request (e.g., no-referrer).

  String get referrerPolicy => _internal["referrerPolicy"];

  /// Contains the mode of the request.

  RequestMode get mode {
    String m = _internal["mode"];
    if (m == "no-cors") return RequestMode.NO_CORS;
    if (m == "same-origin") return RequestMode.SAME_ORIGIN;
    if (m == "navigate") return RequestMode.NAVIGATE;
    return RequestMode.CORS;
  }

  /// Contains the credentials of the request (e.g., omit, same-origin).

  RequestCredentials get credentials {
    String c = _internal["credentials"];
    if (c == "same-origin") return RequestCredentials.SAME_ORIGIN;
    if (c == "include") return RequestCredentials.INCLUDE;
    return RequestCredentials.OMIT;
  }

  /// Contains the mode for how redirects are handled. It may be one of follow,
  /// error, or manual.

  RedirectMode get redirect {
    String r = _internal["redirect"];
    if (r == "error") return RedirectMode.ERROR;
    if (r == "manual") return RedirectMode.MANUAL;
    return RedirectMode.FOLLOW;
  }

  /// Contains the subresource integrity value of the request (e.g.,
  /// sha256-BpfBw7ivV8q2jLiT13fxDYAe2tJllusRSZ273h2nFSE=).

  String get integrity => _internal["integrity"];

  /// Contains the cache mode of the request (e.g., default, reload, no-cache).

  CacheMode get cache {
    String c = _internal["credentials"];
    if (c == "no-store") return CacheMode.NO_STORE;
    if (c == "reload") return CacheMode.RELOAD;
    if (c == "no-cache") return CacheMode.NO_CACHE;
    if (c == "force-cache") return CacheMode.FORCE_CACHE;
    return CacheMode.DEFAULT;
  }

  /// Creates a copy of the current Request object.

  Request clone() => new Request.fromInternal(_internal.callMethod("clone"));

  JsObject toJs() => _internal;

  JsObject _internal;
}

Future<Response> fetch(
    {Request request,
    String url,
    RequestMethod method,
    Headers headers,
    body,
    RequestMode mode,
    RequestCredentials credentials,
    CacheMode cache,
    RedirectMode redirect,
    String referrer,
    String integrity}) async {
  if (request == null && url == null) return null;
  var options = {};
  if (method != null) {
    if (method == RequestMethod.GET)
      options["method"] = "GET";
    else if (mode == RequestMethod.POST) options["method"] = "POST";
  }
  if (headers != null) options["headers"] = headers._internal;
  if (body != null) options["body"] = body;
  if (mode != null) {
    if (mode == RequestMode.CORS)
      options["mode"] = "cors";
    else if (mode == RequestMode.NO_CORS)
      options["mode"] = "no-cors";
    else if (mode == RequestMode.SAME_ORIGIN)
      options["mode"] = "same-origin";
    else if (mode == RequestMode.NAVIGATE) options["mode"] = "navigate";
  }
  if (credentials != null) {
    if (credentials == RequestCredentials.OMIT)
      options["credentials"] = "omit";
    else if (credentials == RequestCredentials.SAME_ORIGIN)
      options["credentials"] = "same-origin";
    else if (credentials == RequestCredentials.INCLUDE)
      options["credentials"] = "include";
  }
  if (cache != null) {
    if (cache == CacheMode.DEFAULT)
      options["cache"] = "default";
    else if (cache == CacheMode.NO_STORE)
      options["cache"] = "same-origin";
    else if (cache == CacheMode.RELOAD)
      options["cache"] = "reload";
    else if (cache == CacheMode.NO_CACHE)
      options["cache"] = "no-cache";
    else if (cache == CacheMode.FORCE_CACHE) options["cache"] = "force-cache";
  }
  if (redirect != null) {
    if (redirect == RedirectMode.FOLLOW)
      options["redirect"] = "default";
    else if (redirect == RedirectMode.ERROR)
      options["redirect"] = "error";
    else if (redirect == RedirectMode.MANUAL) options["redirect"] = "manual";
  }
  if (referrer != null) options["referrer"] = referrer;
  if (integrity != null) options["integrity"] = integrity;
  var req = (request != null) ? request.toJs() : url;
  Completer c = new Completer();
  JsObject promise = context.callMethod("fetch", [req, options]);
  promise.callMethod("then", [
    (jsresponse) {
      c.complete(new Response.internal(jsresponse));
    }
  ]);
  return await c.future;
}
