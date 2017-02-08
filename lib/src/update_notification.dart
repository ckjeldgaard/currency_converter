class UpdateNotification {
  final int _timestamp;

  UpdateNotification(this._timestamp);

  int get timestamp => _timestamp;

  @override
  String toString() {
    return 'UpdateNotification{_timestamp: $_timestamp}';
  }
}