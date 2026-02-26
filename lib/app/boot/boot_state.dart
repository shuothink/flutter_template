import 'package:equatable/equatable.dart';

enum BootStatus { initial, loading, success, failure }

enum BootStep { none, storage, network, dependencies, auth, complete }

class BootState extends Equatable {
  final BootStatus status;
  final BootStep currentStep;
  final String? errorMessage;
  final double progress;
  final String? nextRoute;
  final List<String> warnings;

  const BootState({
    this.status = BootStatus.initial,
    this.currentStep = BootStep.none,
    this.errorMessage,
    this.progress = 0.0,
    this.nextRoute,
    this.warnings = const <String>[],
  });

  BootState copyWith({
    BootStatus? status,
    BootStep? currentStep,
    String? errorMessage,
    double? progress,
    String? nextRoute,
    List<String>? warnings,
    bool clearError = false,
    bool clearWarnings = false,
  }) {
    return BootState(
      status: status ?? this.status,
      currentStep: currentStep ?? this.currentStep,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      progress: progress ?? this.progress,
      nextRoute: nextRoute ?? this.nextRoute,
      warnings: clearWarnings ? const <String>[] : (warnings ?? this.warnings),
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentStep,
    errorMessage,
    progress,
    nextRoute,
    warnings,
  ];
}
