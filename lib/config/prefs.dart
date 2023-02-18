import 'package:flutter/material.dart';
import 'package:flutter_movies_app/config/config.dart';
import 'package:flutter_movies_app/constants/strings.dart';

/// [SystemPreferences] is a global settings management system which uses [ChangeNotifier]
/// send change notifications when [ChangeNotifier.notifyListeners] is called
class SystemPreferences extends ChangeNotifier {
  SystemPreferences() {
    _isDark = getIsDarkThemeMode();
    _isSystemDefault = getSystemThemeMode();
  }

  static bool _isDark = true;
  static bool _isSystemDefault = true;

  String getApiKey() => box.get(Strings.prefApiKey, defaultValue: '');

  saveApiKey(String key) {
    box.put(Strings.prefApiKey, key);
    notifyListeners();
  }

  ThemeMode currentTheme() => _isSystemDefault ? ThemeMode.system : (_isDark ? ThemeMode.dark : ThemeMode.light);

  bool getIsDarkThemeMode() => box.get(Strings.prefDarkModeKey, defaultValue: true);

  switchThemeMode() {
    _isDark = !_isDark;
    box.put(Strings.prefDarkModeKey, _isDark);
    notifyListeners();
  }

  bool getSystemThemeMode() => box.get(Strings.prefSystemThemeKey, defaultValue: true);

  switchToSystemThemeMode() {
    _isSystemDefault = !_isSystemDefault;
    box.put(Strings.prefSystemThemeKey, _isSystemDefault);
    notifyListeners();
  }
}
