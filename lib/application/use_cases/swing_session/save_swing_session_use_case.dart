import '../../../domain/entities/swing_session.dart';
import '../../../domain/repositories/i_swing_session_repository.dart';

class SaveSwingSessionUseCase {
  final ISwingSessionRepository _repository;
  SaveSwingSessionUseCase(this._repository);

  Future<SwingSession> execute(SwingSession session) =>
      _repository.save(session);
}
