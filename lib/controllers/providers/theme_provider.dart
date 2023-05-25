import 'package:flutter/material.dart';
import 'package:weather_app/models/theme_model.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeModel themeModel;

  ThemeProvider({required this.themeModel});

  changeTheme() {
    themeModel.isDark = !themeModel.isDark;
    notifyListeners();
  }
}
