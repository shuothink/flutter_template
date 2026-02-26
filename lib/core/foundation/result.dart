import 'package:flutter_template/core/foundation/errors.dart';

sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;

  factory Result.failure(Failure error) = Failed<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure error) failure,
  }) {
    return switch (this) {
      Success(data: final data) => success(data),
      Failed(error: final error) => failure(error),
    };
  }

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is Failed<T>;

  T? get dataOrNull => switch (this) {
    Success(data: final data) => data,
    Failed() => null,
  };

  Failure? get errorOrNull => switch (this) {
    Success() => null,
    Failed(error: final error) => error,
  };

  Result<R> map<R>(R Function(T data) transform) {
    return when(
      success: (data) => Result.success(transform(data)),
      failure: (error) => Result.failure(error),
    );
  }

  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    return when(
      success: (data) => transform(data),
      failure: (error) => Result.failure(error),
    );
  }
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success(data: $data)';
}

class Failed<T> extends Result<T> {
  final Failure error;

  const Failed(this.error);

  @override
  String toString() => 'Failed(error: $error)';
}
