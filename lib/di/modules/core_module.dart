import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_template/app/router/names.dart';
import 'package:flutter_template/app/router/pages.dart';
import 'package:flutter_template/core/config/env.dart';
import 'package:flutter_template/core/foundation/logger.dart';
import 'package:flutter_template/core/network/network_client.dart';
import 'package:flutter_template/core/utils/storage.dart';

class CoreModule {
  CoreModule._();

  static Future<void> register(GetIt getIt) async {
    AppLogger.i('Registering core module...', tag: 'di');

    await StorageImpl.initialize();

    NetworkClient.instance.initialize(
      baseUrl: AppEnv.baseUrl,
      tokenProvider: StorageImpl.getToken,
      onUnauthorized: _handleUnauthorized,
    );
    if (!getIt.isRegistered<NetworkClient>()) {
      getIt.registerSingleton<NetworkClient>(NetworkClient.instance);
    }

    AppLogger.i('Core module registered', tag: 'di');
  }

  static void _handleUnauthorized() {
    unawaited(StorageImpl.clearAuthSession());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = rootNavigatorKey.currentState;
      navigator?.popUntil((route) => route.isFirst);
      router.go(RouterNames.loginPath);
    });
  }
}
