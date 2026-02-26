import 'package:flutter/material.dart';
import 'package:flutter_template/app/theme/app_theme.dart';

class AppThemes {
  AppThemes._();

  static final ThemeData light = AppTheme.buildLightTheme();
  static final ThemeData dark = AppTheme.buildDarkTheme();
}
