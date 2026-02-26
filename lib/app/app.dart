import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_template/app/router/pages.dart';
import 'package:flutter_template/app/theme/theme_mode_controller.dart';
import 'package:flutter_template/app/theme/themes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeModeController.notifier,
      builder: (context, themeMode, _) {
        final isDarkMode = themeMode == ThemeMode.dark;
        final defaultOverlayStyle = isDarkMode
            ? const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              )
            : const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              );

        return MaterialApp.router(
          routerConfig: router,
          builder: (context, child) {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: defaultOverlayStyle,
              child: child ?? const SizedBox.shrink(),
            );
          },
          locale: const Locale('zh', 'CN'),
          supportedLocales: const [Locale('zh', 'CN')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          title: 'Flutter Template', // TODO: 替换为你的应用名称
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
