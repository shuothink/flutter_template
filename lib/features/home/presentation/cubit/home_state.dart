import 'package:equatable/equatable.dart';
import 'package:flutter_template/core/foundation/errors.dart';
import 'package:flutter_template/features/home/domain/entities/home_data_entity.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.data,
    this.failure,
  });

  final HomeStatus status;
  final HomeDataEntity? data;
  final Failure? failure;

  HomeState copyWith({
    HomeStatus? status,
    HomeDataEntity? data,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, data, failure];
}
