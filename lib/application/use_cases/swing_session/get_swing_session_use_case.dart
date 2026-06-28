import '../../../domain/entities/swing_session.dart';
import '../../../domain/exceptions/swing_session_not_found_exception.dart';
import '../../../domain/repositories/i_swing_session_repository.dart';

class GetSwingSessionUseCase {
  final ISwingSessionRepository _repository;
  GetSwingSessionUseCase(this._repository);

  Future<SwingSession> execute(int id) async {
    final session = await _repository.getById(id);
    if (session == null) {
      throw SwingSessionNotFoundException('セッションが見つかりません（id: $id）');
    }
    return session;
  }
}
