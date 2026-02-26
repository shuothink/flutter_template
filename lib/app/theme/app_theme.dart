import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/design_system/tokens/design_tokens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: DesignTokens.primaryColor,
        secondary: DesignTokens.primaryLightColor,
        error: DesignTokens.errorColor,
        surface: DesignTokens.surfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: DesignTokens.textPrimaryColor,
      ),
      scaffoldBackgroundColor: DesignTokens.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignTokens.backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: DesignTokens.textPrimaryColor,
          fontSize: DesignTokens.fontSizeLg,
          fontWeight: DesignTokens.fontWeightMedium,
        ),
        iconTheme: IconThemeData(color: DesignTokens.textPrimaryColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: DesignTokens.backgroundColor,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      textTheme: _buildTextTheme(
        primaryColor: DesignTokens.textPrimaryColor,
        secondaryColor: DesignTokens.textSecondaryColor,
      ),
      cardTheme: const CardThemeData(
        color: DesignTokens.surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(DesignTokens.radiusLg),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceMd,
          vertical: DesignTokens.spaceBase,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
          borderSide: const BorderSide(color: DesignTokens.dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
          borderSide: const BorderSide(color: DesignTokens.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
          borderSide: const BorderSide(
            color: DesignTokens.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
          borderSide: const BorderSide(color: DesignTokens.errorColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceLg,
            vertical: DesignTokens.spaceBase,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: DesignTokens.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: DesignTokens.dividerColor,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: DesignTokens.primaryColor,
        secondary: DesignTokens.primaryLightColor,
        error: DesignTokens.errorColor,
        surface: DesignTokens.darkSurfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: DesignTokens.darkTextPrimaryColor,
      ),
      scaffoldBackgroundColor: DesignTokens.darkBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignTokens.darkBackgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: DesignTokens.darkTextPrimaryColor,
          fontSize: DesignTokens.fontSizeLg,
          fontWeight: DesignTokens.fontWeightMedium,
        ),
        iconTheme: IconThemeData(color: DesignTokens.darkTextPrimaryColor),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: DesignTokens.darkBackgroundColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      textTheme: _buildTextTheme(
        primaryColor: DesignTokens.darkTextPrimaryColor,
        secondaryColor: DesignTokens.darkTextSecondaryColor,
      ),
      cardTheme: const CardThemeData(
        color: DesignTokens.darkSurfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(DesignTokens.radiusLg),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignTokens.darkSurfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spaceMd,
          vertical: DesignTokens.spaceBase,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
          borderSide: const BorderSide(color: DesignTokens.darkDividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
          borderSide: const BorderSide(color: DesignTokens.darkDividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
          borderSide: const BorderSide(
            color: DesignTokens.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusBase),
          borderSide: const BorderSide(color: DesignTokens.errorColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignTokens.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.spaceLg,
            vertical: DesignTokens.spaceBase,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: DesignTokens.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: DesignTokens.darkDividerColor,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static TextTheme _buildTextTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: DesignTokens.fontSize3xl,
        fontWeight: DesignTokens.fontWeightBold,
        color: primaryColor,
      ),
      displayMedium: TextStyle(
        fontSize: DesignTokens.fontSize2xl,
        fontWeight: DesignTokens.fontWeightBold,
        color: primaryColor,
      ),
      displaySmall: TextStyle(
        fontSize: DesignTokens.fontSizeXl,
        fontWeight: DesignTokens.fontWeightBold,
        color: primaryColor,
      ),
      headlineLarge: TextStyle(
        fontSize: DesignTokens.fontSizeLg,
        fontWeight: DesignTokens.fontWeightMedium,
        color: primaryColor,
      ),
      headlineMedium: TextStyle(
        fontSize: DesignTokens.fontSizeMd,
        fontWeight: DesignTokens.fontWeightMedium,
        color: primaryColor,
      ),
      headlineSmall: TextStyle(
        fontSize: DesignTokens.fontSizeBase,
        fontWeight: DesignTokens.fontWeightMedium,
        color: primaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: DesignTokens.fontSizeMd,
        fontWeight: DesignTokens.fontWeightNormal,
        color: primaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: DesignTokens.fontSizeBase,
        fontWeight: DesignTokens.fontWeightNormal,
        color: primaryColor,
      ),
      bodySmall: TextStyle(
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: DesignTokens.fontWeightNormal,
        color: secondaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: DesignTokens.fontSizeBase,
        fontWeight: DesignTokens.fontWeightMedium,
        color: primaryColor,
      ),
      labelMedium: TextStyle(
        fontSize: DesignTokens.fontSizeSm,
        fontWeight: DesignTokens.fontWeightMedium,
        color: secondaryColor,
      ),
      labelSmall: TextStyle(
        fontSize: DesignTokens.fontSizeXs,
        fontWeight: DesignTokens.fontWeightNormal,
        color: secondaryColor,
      ),
    );
  }
}
