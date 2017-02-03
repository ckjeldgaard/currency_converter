library ServiceWorker.Cache;

import 'dart:async';
import 'dart:js';

import 'util.dart';
import 'fetch.dart';

class Cache implements JsProxyObject {
  Cache.internal(this._internal) {}

  /// Returns a [Future] that resolves to the response associated with the
  /// first matching request in the [Cache] object.

  Future<Response> match(
      {Request request,
      String url,
      bool ignoreSearch,
      bool ignoreMethod,
      bool ignoreVary}) async {
    if (request == null && url == null) return null;
    Completer c = new Completer();
    var req = (request != null) ? request.toJs() : url;
    var options = {};
    if (ignoreSearch != null) options["ignoreSearch"] = ignoreSearch;
    if (ignoreMethod != null) options["ignoreMethod"] = ignoreMethod;
    if (ignoreVary != null) options["ignoreVary"] = ignoreVary;
    JsObject promise = _internal.callMethod("match", [req, options]);
    promise.callMethod("then", [
      (response) {
        c.complete(new Response.internal(response));
      }
    ]);
    return await c.future;
  }

  /// Returns a [Future] that resolves to an array of all matching requests
  /// in the [Cache] object.

  Future<List<Response>> matchAll(
      {Request request,
      String url,
      bool ignoreSearch,
      bool ignoreMethod,
      bool ignoreVary}) async {
    if (request == null && url == null) return null;
    Completer c = new Completer();
    var req = (request != null) ? request.toJs() : url;
    var options = {};
    if (ignoreSearch != null) options["ignoreSearch"] = ignoreSearch;
    if (ignoreMethod != null) options["ignoreMethod"] = ignoreMethod;
    if (ignoreVary != null) options["ignoreVary"] = ignoreVary;
    JsObject promise = _internal.callMethod("match", [req, options]);
    promise.callMethod("then", [
      (jsresponses) {
        var responses = [];
        for (JsObject response in jsresponses) {
          responses.add(new Response.internal(response));
        }
        c.complete(responses);
      }
    ]);
    return await c.future;
  }

  /// Takes a URL, retrieves it and adds the resulting response object to the
  /// given cache. This is fuctionally equivalent to calling fetch(), then
  /// using put() to add the results to the cache.

  Future add({Request request, String url}) async {
    if (request == null && url == null) return;
    var req = (request != null) ? request.toJs() : url;
    Completer c = new Completer();
    JsObject promise = _internal.callMethod("add", [req]);
    promise.callMethod("then", [
      (_) {
        c.complete();
      }
    ]);
    await c.future;
    return;
  }

  /// Takes an array of URLs, retrieves them, and adds the resulting response
  /// objects to the given cache.

  Future addAll({List<Request> requests, List<String> urls}) async {
    if (requests == null && urls == null) return;
    var req;
    if (requests != null) {
      req = [];
      for (Request r in requests) {
        req.add(r.toJs());
      }
    } else
      req = urls;
    Completer c = new Completer();
    JsObject promise = _internal.callMethod("addAll", [new JsArray.from(req)]);
    promise.callMethod("then", [
      (_) {
        c.complete();
      }
    ]);
    await c.future;
    return;
  }

  /// Takes both a request and its response and adds it to the given cache.

  Future put(Request request, Response response) async {
    Completer c = new Completer();
    JsObject promise =
        _internal.callMethod("put", [request.toJs(), response.toJs()]);
    promise.callMethod("then", [
      (_) {
        c.complete();
      }
    ]);
    await c.future;
    return;
  }

  /// Finds the [Cache] entry whose key is the request, and if found, deletes
  /// the [Cache] entry and returns a [Future] that resolves to `true`.
  /// If no [Cache] entry is found, it returns `false`.

  Future delete(
      {Request request,
      String url,
      bool ignoreSearch,
      bool ignoreMethod,
      bool ignoreVary}) async {
    if (request == null && url == null) return;
    Completer c = new Completer();
    var req = (request != null) ? request.toJs() : url;
    var options = {};
    if (ignoreSearch != null) options["ignoreSearch"] = ignoreSearch;
    if (ignoreMethod != null) options["ignoreMethod"] = ignoreMethod;
    if (ignoreVary != null) options["ignoreVary"] = ignoreVary;
    JsObject promise = _internal.callMethod("put", [req, options]);
    promise.callMethod("then", [
      (_) {
        c.complete();
      }
    ]);
    await c.future;
    return;
  }

  /// Returns a [Future] that resolves to an array of [Cache] keys.

  Future<List<Request>> keys(
      {bool ignoreSearch, bool ignoreMethod, bool ignoreVary}) async {
    Completer c = new Completer();
    var options = {};
    if (ignoreSearch != null) options["ignoreSearch"] = ignoreSearch;
    if (ignoreMethod != null) options["ignoreMethod"] = ignoreMethod;
    if (ignoreVary != null) options["ignoreVary"] = ignoreVary;
    JsObject promise = _internal.callMethod("put", [options]);
    promise.callMethod("then", [
      (jskeys) {
        var keys = [];
        for (JsObject key in jskeys) {
          keys.add(new Request.fromInternal(key));
        }
        c.complete(keys);
      }
    ]);
    return await c.future;
  }

  JsObject toJs() => _internal;

  JsObject _internal;
}

final CacheStorage caches = new CacheStorage.internal(context["caches"]);

class CacheStorage implements JsProxyObject {
  CacheStorage.internal(this._internal) {}

  /// Returns a [Future] that resolves to the [Cache] object matching the
  /// `cacheName` (a new cache is created if it doesn't exist.)

  Future<Cache> open(String cacheName) async {
    Completer c = new Completer();
    JsObject promise = _internal.callMethod("open", [cacheName]);
    promise.callMethod("then", [
      (jscache) {
        var cache = new Cache.internal(jscache);
        c.complete(cache);
      }
    ]);
    return await c.future;
  }

  /// Checks if a given [Request] is a key in any of the Cache objects that
  /// the [CacheStorage] object tracks and returns a [Future] that resolves
  /// to that match.

  Future<Response> match(Request request,
      {bool ignoreSearch: false,
      bool ignoreMethod: false,
      bool ignoreVary: false,
      String cacheName}) async {
    Completer c = new Completer();
    var opts = {
      "ignoreSearch": ignoreSearch,
      "ignoreMethod": ignoreMethod,
      "ignoreVary": ignoreVary
    };
    if (cacheName != null) opts["cacheName"] = cacheName;
    JsObject options = new JsObject.jsify(opts);
    JsObject promise = _internal.callMethod("match", [request.toJs(), options]);
    promise.callMethod("then", [
      (response) {
        if (response == null) {
          c.complete(null);
          return;
        }
        c.complete(new Response.internal(response));
      }
    ]);
    return await c.future;
  }

  /// Returns a [Future] that resolves to `true` if a [Cache] object matching
  /// the `cacheName` exists.

  Future<bool> has(String cacheName) async {
    Completer c = new Completer();
    JsObject promise = _internal.callMethod("has", [cacheName]);
    promise.callMethod("then", [
      (response) {
        c.complete(response as bool);
      }
    ]);
    return await c.future;
  }

  /// Finds the [Cache] object matching the `cacheName`, and if found, deletes
  /// the [Cache] object and returns a [Future] that resolves to `true`.
  /// If no [Cache] object is found, it returns `false`.

  Future<bool> delete(String cacheName) async {
    Completer c = new Completer();
    JsObject promise = _internal.callMethod("delete", [cacheName]);
    promise.callMethod("then", [
      (response) {
        c.complete(response as bool);
      }
    ]);
    return await c.future;
  }

  /// Returns a [Future] that will resolve with an array containing strings
  /// corresponding to all of the named [Cache] objects tracked by the
  /// [CacheStorage]. Use this method to iterate over a list of all the
  /// [Cache] objects.

  Future<List<String>> keys() async {
    Completer c = new Completer();
    JsObject promise = _internal.callMethod("keys");
    promise.callMethod("then", [
      (keys) {
        c.complete((keys as JsArray).toList());
      }
    ]);
    return await c.future;
  }

  JsObject toJs() => _internal;

  JsObject _internal;
}
