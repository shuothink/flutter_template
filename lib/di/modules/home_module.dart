import 'package:get_it/get_it.dart';
import 'package:flutter_template/core/foundation/logger.dart';
import 'package:flutter_template/core/network/network.dart';
import 'package:flutter_template/features/home/application/usecases/get_home_data_usecase.dart';
import 'package:flutter_template/features/home/data/datasources/home_remote_data_source.dart';
import 'package:flutter_template/features/home/data/repositories_impl/home_repository_impl.dart';
import 'package:flutter_template/features/home/domain/repositories/home_repository.dart';

class HomeModule {
  HomeModule._();

  static Future<void> register(GetIt getIt) async {
    AppLogger.i('Registering home module...', tag: 'di');

    if (!getIt.isRegistered<HomeRemoteDataSource>()) {
      getIt.registerLazySingleton<HomeRemoteDataSource>(
        () => HomeRemoteDataSourceImpl(const RequestExecutor()),
      );
    }

    if (!getIt.isRegistered<HomeRepository>()) {
      getIt.registerLazySingleton<HomeRepository>(
        () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
      );
    }

    if (!getIt.isRegistered<GetHomeDataUseCase>()) {
      getIt.registerFactory<GetHomeDataUseCase>(
        () => GetHomeDataUseCase(getIt<HomeRepository>()),
      );
    }

    AppLogger.i('Home module registered', tag: 'di');
  }
}
