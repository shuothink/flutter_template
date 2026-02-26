import 'package:flutter_template/core/foundation/result.dart';
import 'package:flutter_template/features/home/data/datasources/home_remote_data_source.dart';
import 'package:flutter_template/features/home/domain/entities/home_data_entity.dart';
import 'package:flutter_template/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Result<HomeDataEntity>> getHomeData() {
    return _remoteDataSource.getHomeData();
  }
}
