abstract class ConverterView {
  void showLoading();
  void showContent();
  void showError(Exception e);
  void swap();
}

abstract class ConverterUserActions {
  void quack();
}