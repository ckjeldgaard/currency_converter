library ServiceWorkerManager.Worker;

import 'dart:async';
import 'shared.dart';
//import 'dart:html' as HTML;
import 'dart:js';

enum ServiceWorkerState {
  INSTALLING,
  INSTALLED,
  ACTIVATING,
  ACTIVATED,
  REDUNDANT,
  UNDEFINED
}

class StateChangeEvent {
  StateChangeEvent(this.oldState, this.newState) {}
  final ServiceWorkerState oldState;
  final ServiceWorkerState newState;
}

class ServiceWorker {
  ServiceWorker.internal(this._internal) {
    JsObject reg = _internal;
    reg.callMethod("addEventListener",["statechange",(event) {
      var nstate;
      switch (event["state"]) {
        case 0:
          nstate = ServiceWorkerState.INSTALLING;
          break;
        case 1:
          nstate = ServiceWorkerState.INSTALLED;
          break;
        case 2:
          nstate = ServiceWorkerState.ACTIVATING;
          break;
        case 3:
          nstate = ServiceWorkerState.ACTIVATED;
          break;
        case 4:
          nstate = ServiceWorkerState.REDUNDANT;
          break;
        default:
          nstate = ServiceWorkerState.UNDEFINED;
          break;
      }
      var sce = new StateChangeEvent(_state, nstate);
      _state = nstate;
      _stateController.add(sce);
    }]);
    _scope = reg["scope"];
    reg.callMethod("addEventListener",["message",(event) {
      var me = new MessageEvent(event["data"], "", "", "");
      _messageController.add(me);
    }]);
    reg.callMethod("addEventListener",["error",(event) {
      _errorController.add(event);
    }]);
  }

  /// Returns a unique identifier for a service worker registration. This must
  /// be on the same origin as the document that registers the [ServiceWorker].

  String get scope => _scope;

  /// Returns the state of the service worker. It returns one of the following
  /// values: installing, installed, activating, activated, or redundant.

  ServiceWorkerState get state => _state;

  /// Returns a [Stream] which fires an event when the state changes.

  Stream<StateChangeEvent> get onStateChange => _stateController.stream;

  /// Returns a [Stream] which fires an event when the service worker sent a
  /// message.

  Stream<MessageEvent> get onMessage => _messageController.stream;

  /// Returns a [Stream] which fires an event when an error occured.

  Stream get onError => _errorController.stream;

  /// Post `message` to the service worker.

  void postMessage(message) {
    JsObject sw = _internal["active"];
    if (sw == null) {
      sw = _internal["waiting"];
    }
    if (sw == null) {
      sw = _internal["installing"];
    }
    if (sw == null) {
      throw "Can't post message, ServiceWorker not ready.";
    }
    sw.callMethod("postMessage",[message]);
  }

  /// Checks the server for an updated version of the service worker without
  /// consulting caches.

  void update() {
    _internal.callMethod("update");
  }

  /// Unregisters the service worker and returns a [Future]. The service worker
  /// will finish any ongoing operations before it is unregistered.


  Future unregister() async {
    Completer c = new Completer();
    JsObject promise = _internal.callMethod("unregister");
    promise.callMethod("then",[(_){
      c.complete();
    }]);
    return await c.future;
  }

  ServiceWorkerState _state = ServiceWorkerState.UNDEFINED;
  StreamController _stateController = new StreamController.broadcast();
  StreamController _messageController = new StreamController.broadcast();
  StreamController _errorController = new StreamController.broadcast();
  String _scope;
  var _internal;
}
