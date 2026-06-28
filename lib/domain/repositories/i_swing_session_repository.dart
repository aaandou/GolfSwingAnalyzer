import '../entities/swing_session.dart';

abstract interface class ISwingSessionRepository {
  Future<SwingSession> save(SwingSession session);
  Future<List<SwingSession>> getAll();
  Future<SwingSession?> getById(int id);
  Future<void> delete(int id);
}
