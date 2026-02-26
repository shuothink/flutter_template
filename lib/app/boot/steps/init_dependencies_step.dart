import 'package:flutter_template/app/boot/boot_init_step.dart';
import 'package:flutter_template/app/boot/boot_state.dart';
import 'package:flutter_template/di/injector.dart';

BootInitStep createInitDependenciesStep() {
  return BootInitStep(
    name: '初始化依赖容器',
    step: BootStep.dependencies,
    timeout: const Duration(seconds: 12),
    criticality: BootInitCriticality.fatal,
    run: () async {
      await resetDependencies();
      await setupDependencies();
    },
  );
}
