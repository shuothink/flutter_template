import 'package:flutter_template/core/foundation/result.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> login({
    required String username,
    required String password,
  });

  Future<Result<void>> logout();

  Future<Result<bool>> hasValidSession();
}
