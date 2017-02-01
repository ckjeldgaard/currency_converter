library ServiceWorkerShared;

class MessageEvent {
  MessageEvent(
      this.data, this.origin, this.lastEventId, this.source /*,this.ports*/) {}
  final data;
  final String origin;
  final String lastEventId;
  final source;
  //final List<MessagePort> ports;
}
