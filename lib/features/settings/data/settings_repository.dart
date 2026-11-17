import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  final SharedPreferences prefs;

  SettingsRepository(this.prefs);

  static const _keyThemeMode = 'theme_mode';
  static const _keyLocale = 'locale';
  static const _keyDefaultBrushSize = 'default_brush_size';
  static const _keyDefaultColor = 'default_color';
  static const _keyGestureSensitivity = 'gesture_sensitivity';
  static const _keyHasSeenOnboarding = 'has_seen_onboarding';
  static const _keyDefaultGridStyle = 'default_grid_style';

  ThemeMode getThemeMode() {
    final value = prefs.getString(_keyThemeMode);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
        break;
      case ThemeMode.dark:
        value = 'dark';
        break;
      case ThemeMode.system:
        value = 'system';
        break;
    }
    await prefs.setString(_keyThemeMode, value);
  }

  Locale? getLocale() {
    final code = prefs.getString(_keyLocale);
    if (code == null) return null;
    return Locale(code);
  }

  Future<void> setLocale(String languageCode) async {
    await prefs.setString(_keyLocale, languageCode);
  }

  double getDefaultBrushSize() {
    return prefs.getDouble(_keyDefaultBrushSize) ?? 4.0;
  }

  Future<void> setDefaultBrushSize(double size) async {
    await prefs.setDouble(_keyDefaultBrushSize, size);
  }

  Color getDefaultColor() {
    final val = prefs.getInt(_keyDefaultColor);
    if (val == null) return const Color(0xFF191A2E);
    return Color(val);
  }

  Future<void> setDefaultColor(Color color) async {
    await prefs.setInt(_keyDefaultColor, color.toARGB32());
  }

  double getGestureSensitivity() {
    return prefs.getDouble(_keyGestureSensitivity) ?? 1.0;
  }

  Future<void> setGestureSensitivity(double sensitivity) async {
    await prefs.setDouble(_keyGestureSensitivity, sensitivity);
  }

  bool hasSeenOnboarding() {
    return prefs.getBool(_keyHasSeenOnboarding) ?? false;
  }

  Future<void> setHasSeenOnboarding(bool seen) async {
    await prefs.setBool(_keyHasSeenOnboarding, seen);
  }

  String getDefaultGridStyle() {
    return prefs.getString(_keyDefaultGridStyle) ?? 'dots';
  }

  Future<void> setDefaultGridStyle(String style) async {
    await prefs.setString(_keyDefaultGridStyle, style);
  }
}
