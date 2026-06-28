import '../../domain/entities/swing_session.dart';
import '../../domain/repositories/i_swing_session_repository.dart';
import '../services/database_service.dart';
import '../services/video_storage_service.dart';

class SwingSessionRepository implements ISwingSessionRepository {
  final DatabaseService _db;
  final VideoStorageService _videoStorage;

  SwingSessionRepository(this._db, this._videoStorage);

  @override
  Future<SwingSession> save(SwingSession session) =>
      _db.insertSession(session);

  @override
  Future<List<SwingSession>> getAll() => _db.getAllSessions();

  @override
  Future<SwingSession?> getById(int id) => _db.getSessionById(id);

  @override
  Future<void> delete(int id) async {
    final session = await _db.getSessionById(id);
    if (session != null) {
      await _videoStorage.delete(session.videoPath.value);
    }
    await _db.deleteSession(id);
  }
}
