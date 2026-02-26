import 'package:flutter_template/core/foundation/result.dart';
import 'package:flutter_template/core/network/request_executor.dart';
import 'package:flutter_template/features/home/domain/entities/home_data_entity.dart';

abstract class HomeRemoteDataSource {
  Future<Result<HomeDataEntity>> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(this._executor);

  final RequestExecutor _executor;

  @override
  Future<Result<HomeDataEntity>> getHomeData() {
    // TODO: 替换为你的首页 API
    return _executor.get(
      path: 'home/overview',
      convert: (data) {
        final map = data as Map<String, dynamic>;
        return HomeDataEntity(
          greeting: map['greeting']?.toString() ?? 'Hello',
          items: (map['items'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
        );
      },
    );
  }
}
