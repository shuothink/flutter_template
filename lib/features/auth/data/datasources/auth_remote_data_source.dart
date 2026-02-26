import 'package:flutter_template/core/foundation/result.dart';
import 'package:flutter_template/core/network/request_executor.dart';
import 'package:flutter_template/features/auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<Result<UserEntity>> login({
    required String username,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._executor);

  final RequestExecutor _executor;

  @override
  Future<Result<UserEntity>> login({
    required String username,
    required String password,
  }) {
    // TODO: 替换为你的登录 API
    return _executor.post(
      path: 'auth/login',
      data: {'username': username, 'password': password},
      convert: (data) {
        final map = data as Map<String, dynamic>;
        return UserEntity(
          userId: map['userId']?.toString() ?? '',
          username: map['username']?.toString() ?? '',
          email: map['email']?.toString(),
          avatar: map['avatar']?.toString(),
        );
      },
    );
  }
}
