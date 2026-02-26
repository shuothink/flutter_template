import 'package:flutter_template/app/boot/boot_init_step.dart';
import 'package:flutter_template/app/boot/boot_state.dart';
import 'package:flutter_template/app/theme/theme_mode_controller.dart';
import 'package:flutter_template/core/foundation/logger.dart';
import 'package:flutter_template/core/utils/storage.dart';

BootInitStep createRestorePreferencesStep() {
  return BootInitStep(
    name: '恢复本地偏好设置',
    step: BootStep.storage,
    timeout: const Duration(seconds: 2),
    criticality: BootInitCriticality.degradable,
    run: () async {
      final locale = StorageImpl.getLocale();
      final darkMode = StorageImpl.getDarkMode();
      ThemeModeController.restoreFromStorage(darkMode: darkMode);
      AppLogger.i(
        'Preferences restored: locale=${locale ?? 'default'}, darkMode=${darkMode ?? false}',
        tag: 'boot',
      );
    },
  );
}
