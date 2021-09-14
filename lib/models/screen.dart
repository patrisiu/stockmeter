import 'package:scoped_model/scoped_model.dart';

mixin ScreenModel on Model {
  int _screen = 0;

  int get currentScreen => _screen;

  void updateScreen(int index) {
    _screen = index;
    notifyListeners();
  }
}
