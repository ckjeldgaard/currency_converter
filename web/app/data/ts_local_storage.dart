import 'dart:html';
import 'local_storage.dart';

class TsLocalStorage implements LocalStorage {

  static final String _KEY = "currentTimestamp";
  Storage _localStorage;

  TsLocalStorage() {
    this._localStorage = window.localStorage;
  }

  @override
  int getCurrentTimestamp() {
    return int.parse(_localStorage[_KEY]);
  }

  @override
  void setCurrentTimestamp(int ts) {
    _localStorage[_KEY] = ts.toString();
  }
}