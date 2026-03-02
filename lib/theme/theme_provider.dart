import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color _seedColor = const Color(0xFF6750A4);
  ThemeMode _themeMode = ThemeMode.system;

  Color get seedColor => _seedColor;
  ThemeMode get themeMode => _themeMode;

  /// 12-color preset picker set
  static const List<({Color color, String name})> presetColors = [
    (color: Color(0xFF6750A4), name: 'Violet'),
    (color: Color(0xFF0061A4), name: 'Blue'),
    (color: Color(0xFF006E1C), name: 'Green'),
    (color: Color(0xFFBA1A1A), name: 'Red'),
    (color: Color(0xFF984816), name: 'Orange'),
    (color: Color(0xFF006A60), name: 'Teal'),
    (color: Color(0xFF7D5260), name: 'Rose'),
    (color: Color(0xFF1C588A), name: 'Indigo'),
    (color: Color(0xFF4A6741), name: 'Olive'),
    (color: Color(0xFFAB4600), name: 'Amber'),
    (color: Color(0xFF00629A), name: 'Cyan'),
    (color: Color(0xFF6B2D6B), name: 'Plum'),
  ];

  ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
        fontFamily: "Absans",
      );

  ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        fontFamily: "Absans",
      );

  void setSeedColor(Color color) {
    _seedColor = color;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
