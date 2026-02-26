import 'package:flutter_template/app/boot/boot_init_step.dart';
import 'package:flutter_template/app/boot/boot_state.dart';
import 'package:flutter_template/app/router/names.dart';
import 'package:flutter_template/di/injector.dart';
import 'package:flutter_template/features/auth/application/usecases/check_auth_session_usecase.dart';

BootInitStep createResolveAuthRouteStep({
  required void Function(String route) onRouteResolved,
}) {
  return BootInitStep(
    name: '恢复认证状态',
    step: BootStep.auth,
    timeout: const Duration(seconds: 5),
    criticality: BootInitCriticality.fatal,
    run: () async {
      final checkAuthSessionUseCase = getIt<CheckAuthSessionUseCase>();
      final sessionResult = await checkAuthSessionUseCase();
      final hasSession = sessionResult.when(
        success: (value) => value,
        failure: (error) => throw error,
      );
      onRouteResolved(
        hasSession ? RouterNames.homePath : RouterNames.loginPath,
      );
    },
  );
}
