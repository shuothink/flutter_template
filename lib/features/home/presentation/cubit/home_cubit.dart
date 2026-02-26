import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/foundation/logger.dart';
import 'package:flutter_template/features/home/application/usecases/get_home_data_usecase.dart';
import 'package:flutter_template/features/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetHomeDataUseCase getHomeDataUseCase,
  }) : _getHomeDataUseCase = getHomeDataUseCase,
       super(const HomeState());

  final GetHomeDataUseCase _getHomeDataUseCase;

  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading, clearFailure: true));

    final result = await _getHomeDataUseCase();

    result.when(
      success: (data) {
        AppLogger.i('Home data loaded', tag: 'home');
        emit(state.copyWith(status: HomeStatus.success, data: data));
      },
      failure: (failure) {
        AppLogger.e('Home data load failed: ${failure.message}', tag: 'home');
        emit(state.copyWith(status: HomeStatus.failure, failure: failure));
      },
    );
  }

  Future<void> refresh() => load();
}
