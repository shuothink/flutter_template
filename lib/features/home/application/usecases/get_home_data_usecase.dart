import 'package:flutter_template/core/foundation/result.dart';
import 'package:flutter_template/features/home/domain/entities/home_data_entity.dart';
import 'package:flutter_template/features/home/domain/repositories/home_repository.dart';

class GetHomeDataUseCase {
  GetHomeDataUseCase(this._homeRepository);

  final HomeRepository _homeRepository;

  Future<Result<HomeDataEntity>> call() {
    return _homeRepository.getHomeData();
  }
}
