import 'dart:html';
import 'local_storage.dart';

class TsLocalStorage implements LocalStorage {

  static final String _KEY = "currentTimestamp";
  Storage _localStorage;

  TsLocalStorage() {
    this._localStorage = window.localStorage;
  }

  @override
  String getCurrentTimestamp() {
    return _localStorage[_KEY];
  }

  @override
  void setCurrentTimestamp(String value) {
    _localStorage[_KEY] = value;
  }
}