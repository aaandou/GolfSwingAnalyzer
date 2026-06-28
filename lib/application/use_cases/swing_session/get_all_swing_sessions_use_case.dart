import '../../../domain/entities/swing_session.dart';
import '../../../domain/repositories/i_swing_session_repository.dart';

class GetAllSwingSessionsUseCase {
  final ISwingSessionRepository _repository;
  GetAllSwingSessionsUseCase(this._repository);

  Future<List<SwingSession>> execute() => _repository.getAll();
}
