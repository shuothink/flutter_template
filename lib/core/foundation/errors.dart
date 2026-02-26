import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String code;
  final String message;
  final dynamic data;
  final StackTrace? stackTrace;

  const Failure({
    required this.code,
    required this.message,
    this.data,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [code, message, data];

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

class AppFailure extends Failure {
  const AppFailure({
    required super.code,
    required super.message,
    super.data,
    super.stackTrace,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.code,
    required super.message,
    super.data,
    super.stackTrace,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    required super.code,
    required super.message,
    super.data,
    super.stackTrace,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.code,
    required super.message,
    super.data,
    super.stackTrace,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.code,
    required super.message,
    super.data,
    super.stackTrace,
  });
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.code,
    required super.message,
    this.statusCode,
    super.data,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [...super.props, statusCode];
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message, super.stackTrace})
    : super(code: 'UNEXPECTED_ERROR');
}
