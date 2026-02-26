import 'package:get_it/get_it.dart';
import 'package:flutter_template/core/foundation/logger.dart';
import 'package:flutter_template/core/network/network.dart';
import 'package:flutter_template/features/auth/application/usecases/check_auth_session_usecase.dart';
import 'package:flutter_template/features/auth/application/usecases/login_usecase.dart';
import 'package:flutter_template/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_template/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:flutter_template/features/auth/domain/repositories/auth_repository.dart';

class AuthModule {
  AuthModule._();

  static Future<void> register(GetIt getIt) async {
    AppLogger.i('Registering auth module...', tag: 'di');

    if (!getIt.isRegistered<AuthRemoteDataSource>()) {
      getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(const RequestExecutor()),
      );
    }

    if (!getIt.isRegistered<AuthRepository>()) {
      getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
      );
    }

    if (!getIt.isRegistered<CheckAuthSessionUseCase>()) {
      getIt.registerFactory<CheckAuthSessionUseCase>(
        () => CheckAuthSessionUseCase(getIt<AuthRepository>()),
      );
    }

    if (!getIt.isRegistered<LoginUseCase>()) {
      getIt.registerFactory<LoginUseCase>(
        () => LoginUseCase(getIt<AuthRepository>()),
      );
    }

    AppLogger.i('Auth module registered', tag: 'di');
  }
}
