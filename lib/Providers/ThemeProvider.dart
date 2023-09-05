import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isThemeMode = false;
  ThemeMode themeMode = ThemeMode.light;
  bool isIos = false;
  CupertinoThemeData cupertinoThemeData =
      const CupertinoThemeData(brightness: Brightness.light);
  int defaultPage = 1;

  void platformConvert() {
    isIos = !isIos;
    notifyListeners();
  }

  void pageNo({int index = 1}) {
    defaultPage = index;
    notifyListeners();
  }

  void changeTheme() {
    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
      cupertinoThemeData =
          const CupertinoThemeData(brightness: Brightness.dark);
      isThemeMode = true;
    } else {
      themeMode = ThemeMode.light;
      cupertinoThemeData =
          const CupertinoThemeData(brightness: Brightness.light);
      isThemeMode = false;
    }
    notifyListeners();
  }
}
