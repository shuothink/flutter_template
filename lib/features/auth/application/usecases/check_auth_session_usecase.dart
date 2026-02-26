import 'package:flutter_template/core/foundation/result.dart';
import 'package:flutter_template/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthSessionUseCase {
  CheckAuthSessionUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Result<bool>> call() {
    return _authRepository.hasValidSession();
  }
}
