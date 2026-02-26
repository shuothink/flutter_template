import 'package:flutter_template/core/foundation/result.dart';
import 'package:flutter_template/features/home/domain/entities/home_data_entity.dart';

abstract class HomeRepository {
  Future<Result<HomeDataEntity>> getHomeData();
}
