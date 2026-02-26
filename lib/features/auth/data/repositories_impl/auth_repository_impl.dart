import 'package:flutter_template/core/foundation/result.dart';
import 'package:flutter_template/core/utils/storage.dart';
import 'package:flutter_template/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_template/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Result<UserEntity>> login({
    required String username,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      username: username,
      password: password,
    );

    return result.when(
      success: (user) async {
        // TODO: 从 API 响应中提取 token 并保存
        await StorageImpl.saveAuthSession(
          userId: user.userId,
          accessToken: 'token_from_api',
        );
        return Result.success(user);
      },
      failure: (error) => Result.failure(error),
    );
  }

  @override
  Future<Result<void>> logout() async {
    await StorageImpl.clearAuthSession();
    return Result.success(null);
  }

  @override
  Future<Result<bool>> hasValidSession() async {
    final token = StorageImpl.getToken();
    final userId = StorageImpl.getUserId();
    final hasSession = token != null &&
        token.isNotEmpty &&
        userId != null &&
        userId.isNotEmpty;
    return Result.success(hasSession);
  }
}
