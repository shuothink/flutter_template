import 'package:equatable/equatable.dart';
import 'package:flutter_template/core/foundation/errors.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final UserEntity? user;
  final Failure? failure;

  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.failure,
  });

  LoginState copyWith({
    LoginStatus? status,
    UserEntity? user,
    Failure? failure,
    bool clearUser = false,
    bool clearFailure = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, user, failure];
}
