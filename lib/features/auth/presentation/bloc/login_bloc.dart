import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/foundation/logger.dart';
import 'package:flutter_template/features/auth/application/usecases/login_usecase.dart';
import 'package:flutter_template/features/auth/presentation/bloc/login_event.dart';
import 'package:flutter_template/features/auth/presentation/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required LoginUseCase loginUseCase,
  }) : _loginUseCase = loginUseCase,
       super(const LoginState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final LoginUseCase _loginUseCase;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading, clearFailure: true));

    AppLogger.i('Login attempt for user: ${event.username}', tag: 'LoginBloc');

    final result = await _loginUseCase(
      username: event.username,
      password: event.password,
    );

    result.when(
      success: (user) {
        AppLogger.i(
          'Login successful - userId: ${user.userId}',
          tag: 'LoginBloc',
        );
        emit(state.copyWith(
          status: LoginStatus.success,
          user: user,
          clearFailure: true,
        ));
      },
      failure: (error) {
        AppLogger.e(
          'Login failed - code: ${error.code}, message: ${error.message}',
          tag: 'LoginBloc',
        );
        emit(state.copyWith(status: LoginStatus.failure, failure: error));
      },
    );
  }
}
