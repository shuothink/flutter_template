import 'package:flutter_template/core/foundation/errors.dart';
import 'package:flutter_template/core/foundation/result.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_template/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Result<UserEntity>> call({
    required String username,
    required String password,
  }) async {
    final validationResult = _validateInput(username, password);
    if (validationResult != null) {
      return Result.failure(validationResult);
    }

    return _authRepository.login(
      username: username.trim(),
      password: password.trim(),
    );
  }

  Failure? _validateInput(String username, String password) {
    final trimmedUsername = username.trim();
    final trimmedPassword = password.trim();

    if (trimmedUsername.isEmpty) {
      return const ValidationFailure(
        code: 'INVALID_USERNAME',
        message: '账号不能为空',
      );
    }

    if (trimmedPassword.isEmpty) {
      return const ValidationFailure(
        code: 'INVALID_PASSWORD',
        message: '密码不能为空',
      );
    }
    if (trimmedPassword.length < 6) {
      return const ValidationFailure(
        code: 'INVALID_PASSWORD',
        message: '密码长度不能少于6个字符',
      );
    }

    return null;
  }
}
