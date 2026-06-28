import '../../../domain/repositories/i_swing_session_repository.dart';

class DeleteSwingSessionUseCase {
  final ISwingSessionRepository _repository;
  DeleteSwingSessionUseCase(this._repository);

  Future<void> execute(int id) => _repository.delete(id);
}
