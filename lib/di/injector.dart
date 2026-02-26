import 'package:get_it/get_it.dart';
import 'package:flutter_template/di/modules/core_module.dart';
import 'package:flutter_template/di/modules/auth_module.dart';
import 'package:flutter_template/di/modules/home_module.dart';

final getIt = GetIt.instance;
bool _isInitialized = false;

Future<void> setupDependencies() async {
  if (_isInitialized) return;

  await CoreModule.register(getIt);
  await AuthModule.register(getIt);
  await HomeModule.register(getIt);
  // TODO: 注册更多业务模块

  _isInitialized = true;
}

Future<void> resetDependencies() async {
  await getIt.reset();
  _isInitialized = false;
}
