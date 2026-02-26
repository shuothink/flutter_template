import 'package:flutter/material.dart';

/// 原子级设计令牌，与业务无关，可跨项目复用
class DesignTokens {
  DesignTokens._();

  // ========== Colors ==========

  // TODO: 替换为你的品牌主色
  static const Color primaryColor = Color(0xFF3D31DD);
  static const Color primaryLightColor = Color(0xFF6C63FF);
  static const Color primaryDarkColor = Color(0xFF2A1FA0);

  static const Color successColor = Color(0xFF52C41A);
  static const Color warningColor = Color(0xFFFAAD14);
  static const Color errorColor = Color(0xFFF5222D);
  static const Color infoColor = Color(0xFF3D31DD);

  // Light theme neutrals
  static const Color textPrimaryColor = Color(0xFF000000);
  static const Color textSecondaryColor = Color(0x8C000000);
  static const Color textDisabledColor = Color(0xFFBFBFBF);
  static const Color dividerColor = Color(0xFFEFF0F3);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceColor = Color(0xFFF7F8FA);

  // Dark theme neutrals
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkTextPrimaryColor = Color(0xFFFFFFFF);
  static const Color darkTextSecondaryColor = Color(0xB3FFFFFF);
  static const Color darkDividerColor = Color(0x1FFFFFFF);

  // ========== Typography ==========

  static const double fontSizeXs = 10.0;
  static const double fontSizeSm = 12.0;
  static const double fontSizeBase = 14.0;
  static const double fontSizeMd = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSize2xl = 24.0;
  static const double fontSize3xl = 32.0;

  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // ========== Spacing ==========

  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceBase = 12.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2xl = 48.0;

  // ========== Border Radius ==========

  static const double radiusXs = 2.0;
  static const double radiusSm = 4.0;
  static const double radiusBase = 6.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusRound = 999.0;

  // ========== Shadows ==========

  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 4),
  ];

  static const List<BoxShadow> shadowBase = [
    BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 8),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(color: Color(0x1F000000), offset: Offset(0, 8), blurRadius: 16),
  ];

  // ========== Animation ==========

  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationBase = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  static const Curve curveStandard = Curves.easeInOut;
  static const Curve curveDecelerate = Curves.easeOut;
  static const Curve curveAccelerate = Curves.easeIn;
}
