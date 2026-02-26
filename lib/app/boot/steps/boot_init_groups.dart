import 'package:flutter_template/app/boot/boot_init_step.dart';
import 'package:flutter_template/app/boot/steps/init_dependencies_step.dart';
import 'package:flutter_template/app/boot/steps/restore_preferences_step.dart';
import 'package:flutter_template/app/boot/steps/resolve_auth_route_step.dart';

List<List<BootInitStep>> buildBootInitGroups({
  required void Function(String route) onRouteResolved,
}) {
  return <List<BootInitStep>>[
    // Group 1: DI
    <BootInitStep>[createInitDependenciesStep()],
    // Group 2: Preferences (add more parallel steps here)
    <BootInitStep>[createRestorePreferencesStep()],
    // Group 3: Auth route decision
    // <BootInitStep>[
    //   createResolveAuthRouteStep(onRouteResolved: onRouteResolved),
    // ],
  ];
}
