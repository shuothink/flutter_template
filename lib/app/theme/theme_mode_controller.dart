import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/storage.dart';

abstract final class ThemeModeController {
  static final ValueNotifier<ThemeMode> notifier = ValueNotifier<ThemeMode>(
    ThemeMode.light,
  );

  static void restoreFromStorage({bool? darkMode}) {
    final bool isDark = darkMode ?? StorageImpl.getDarkMode() ?? false;
    notifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> setDarkMode(bool isDark) async {
    notifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
    await StorageImpl.setDarkMode(isDark);
  }

  static bool get isDarkMode => notifier.value == ThemeMode.dark;
}
