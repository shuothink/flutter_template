import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_template/app/router/names.dart';
import 'package:flutter_template/app/boot/boot_page.dart';
import 'package:flutter_template/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_template/features/home/presentation/pages/home_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RouterNames.bootPath,
  routes: <RouteBase>[
    GoRoute(path: '/', redirect: (context, state) => RouterNames.bootPath),
    GoRoute(
      name: RouterNames.bootName,
      path: RouterNames.bootPath,
      builder: (context, state) => const BootPage(),
    ),
    GoRoute(
      name: RouterNames.loginName,
      path: RouterNames.loginPath,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: RouterNames.homeName,
      path: RouterNames.homePath,
      builder: (context, state) => const HomePage(),
    ),
    // TODO: 添加更多路由
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(child: Text('路由不存在: ${state.uri.toString()}')),
    );
  },
);
