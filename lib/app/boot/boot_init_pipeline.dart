import 'package:flutter_template/app/boot/boot_init_step.dart';

typedef BootWarningHandler = void Function(String warning);

class BootInitPipeline {
  BootInitPipeline({
    required List<List<BootInitStep>> groups,
    required this.onWarning,
  }) : _groups = groups;

  final List<List<BootInitStep>> _groups;
  final BootWarningHandler onWarning;

  Future<void> run({
    required Future<void> Function(BootInitStep step) onBeforeStep,
    required Future<void> Function(BootInitStep step) onAfterStep,
  }) async {
    for (final group in _groups) {
      await Future.wait(
        group.map(
          (step) => _runStep(
            step,
            onBeforeStep: onBeforeStep,
            onAfterStep: onAfterStep,
          ),
        ),
      );
    }
  }

  Future<void> _runStep(
    BootInitStep step, {
    required Future<void> Function(BootInitStep step) onBeforeStep,
    required Future<void> Function(BootInitStep step) onAfterStep,
  }) async {
    await onBeforeStep(step);

    try {
      await step.run().timeout(step.timeout);
    } catch (error) {
      if (step.criticality == BootInitCriticality.degradable) {
        onWarning('${step.name} 已降级: $error');
      } else {
        throw BootInitException(message: '${step.name} 执行失败', cause: error);
      }
    } finally {
      await onAfterStep(step);
    }
  }
}
