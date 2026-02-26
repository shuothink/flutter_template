import 'package:flutter_template/app/boot/boot_state.dart';

enum BootInitCriticality { fatal, degradable }

class BootInitStep {
  const BootInitStep({
    required this.name,
    required this.step,
    required this.timeout,
    required this.criticality,
    required this.run,
  });

  final String name;
  final BootStep step;
  final Duration timeout;
  final BootInitCriticality criticality;
  final Future<void> Function() run;
}

class BootInitException implements Exception {
  const BootInitException({required this.message, this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}
