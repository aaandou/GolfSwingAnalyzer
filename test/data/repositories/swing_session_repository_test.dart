import 'package:flutter_test/flutter_test.dart';
import 'package:golf_swing_analyzer/data/repositories/swing_session_repository.dart';
import 'package:golf_swing_analyzer/data/services/database_service.dart';
import 'package:golf_swing_analyzer/data/services/video_storage_service.dart';
import 'package:golf_swing_analyzer/domain/entities/swing_session.dart';
import 'package:golf_swing_analyzer/domain/value_objects/fps.dart';
import 'package:golf_swing_analyzer/domain/value_objects/swing_duration.dart';
import 'package:golf_swing_analyzer/domain/value_objects/video_path.dart';

class _FakeDatabaseService extends DatabaseService {
  _FakeDatabaseService(this._session);
  final SwingSession? _session;
  int? deletedId;

  @override
  Future<SwingSession?> getSessionById(int id) async => _session;

  @override
  Future<void> deleteSession(int id) async {
    deletedId = id;
  }
}

class _FakeVideoStorageService extends VideoStorageService {
  String? deletedPath;

  @override
  Future<void> delete(String videoPath) async {
    deletedPath = videoPath;
  }
}

SwingSession _buildSession() => SwingSession(
  id: 5,
  videoPath: VideoPath('/swings/swing_5.mp4'),
  recordedAt: DateTime(2026, 6, 28),
  duration: SwingDuration(400),
  targetFps: Fps(60),
);

void main() {
  group('SwingSessionRepository.delete', () {
    test('deletes both the DB row and the video file', () async {
      final db = _FakeDatabaseService(_buildSession());
      final storage = _FakeVideoStorageService();
      final repository = SwingSessionRepository(db, storage);

      await repository.delete(5);

      expect(db.deletedId, 5);
      expect(storage.deletedPath, '/swings/swing_5.mp4');
    });

    test('skips video deletion when the session no longer exists', () async {
      final db = _FakeDatabaseService(null);
      final storage = _FakeVideoStorageService();
      final repository = SwingSessionRepository(db, storage);

      await repository.delete(5);

      expect(db.deletedId, 5);
      expect(storage.deletedPath, isNull);
    });
  });
}
