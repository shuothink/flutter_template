import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/app/boot/boot_event.dart';
import 'package:flutter_template/app/boot/boot_init_pipeline.dart';
import 'package:flutter_template/app/boot/boot_init_step.dart';
import 'package:flutter_template/app/boot/steps/boot_init_groups.dart';
import 'package:flutter_template/app/router/names.dart';
import 'package:flutter_template/core/foundation/errors.dart';
import 'package:flutter_template/app/boot/boot_state.dart';
import 'package:flutter_template/core/foundation/logger.dart';

class BootBloc extends Bloc<BootEvent, BootState> {
  BootBloc() : super(const BootState()) {
    on<BootStarted>(_onStarted);
    on<BootRetried>(_onRetried);
  }

  String _nextRoute = RouterNames.homePath;

  Future<void> _onStarted(BootStarted event, Emitter<BootState> emit) async {
    await _initialize(emit);
  }

  Future<void> _onRetried(BootRetried event, Emitter<BootState> emit) async {
    await _initialize(emit);
  }

  Future<void> _initialize(Emitter<BootState> emit) async {
    final startTime = DateTime.now();
    AppLogger.i('Boot initialization started', tag: 'boot');

    try {
      emit(
        state.copyWith(
          status: BootStatus.loading,
          currentStep: BootStep.none,
          progress: 0.0,
          clearError: true,
          clearWarnings: true,
        ),
      );

      final warnings = <String>[];
      var completedSteps = 0;
      final pipeline = _buildPipeline(
        onWarning: (warning) {
          warnings.add(warning);
          emit(state.copyWith(warnings: List<String>.unmodifiable(warnings)));
          AppLogger.w(warning, tag: 'boot');
        },
      );
      final totalSteps = _countTotalSteps();

      await pipeline.run(
        onBeforeStep: (step) async {
          final progress = totalSteps == 0 ? 0.0 : completedSteps / totalSteps;
          emit(state.copyWith(currentStep: step.step, progress: progress));
          AppLogger.i('Step started: ${step.name}', tag: 'boot');
        },
        onAfterStep: (step) async {
          completedSteps += 1;
          final progress = totalSteps == 0 ? 1.0 : completedSteps / totalSteps;
          emit(state.copyWith(currentStep: step.step, progress: progress));
          AppLogger.i('Step finished: ${step.name}', tag: 'boot');
        },
      );

      emit(
        state.copyWith(
          currentStep: BootStep.complete,
          progress: 1.0,
          nextRoute: _nextRoute,
        ),
      );

      final duration = DateTime.now().difference(startTime);
      AppLogger.i(
        'Boot initialization completed in ${duration.inMilliseconds}ms',
        tag: 'boot',
      );

      await Future.delayed(const Duration(milliseconds: 300));

      emit(state.copyWith(status: BootStatus.success));
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime);
      AppLogger.e(
        'Boot initialization failed after ${duration.inMilliseconds}ms: $e',
        tag: 'boot',
        error: e,
        stackTrace: stackTrace,
      );

      final rootCause = switch (e) {
        BootInitException(:final cause) => cause ?? e,
        _ => e,
      };
      final message = switch (rootCause) {
        Failure(:final message) => message,
        _ => rootCause.toString(),
      };
      emit(state.copyWith(status: BootStatus.failure, errorMessage: message));
    }
  }

  int _countTotalSteps() {
    final groups = _buildGroups();
    return groups.fold<int>(0, (count, group) => count + group.length);
  }

  BootInitPipeline _buildPipeline({
    required void Function(String warning) onWarning,
  }) {
    final groups = _buildGroups();
    return BootInitPipeline(groups: groups, onWarning: onWarning);
  }

  List<List<BootInitStep>> _buildGroups() {
    return buildBootInitGroups(
      onRouteResolved: (route) {
        _nextRoute = route;
      },
    );
  }
}
