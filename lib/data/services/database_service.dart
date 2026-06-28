import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/swing_session.dart';
import '../../domain/value_objects/fps.dart';
import '../../domain/value_objects/swing_duration.dart';
import '../../domain/value_objects/video_path.dart';

class DatabaseService {
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'golf_swing_analyzer.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE swing_sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            videoPath TEXT NOT NULL,
            recordedAt TEXT NOT NULL,
            durationMs INTEGER NOT NULL,
            targetFps INTEGER NOT NULL,
            note TEXT,
            impactDetected INTEGER NOT NULL DEFAULT 1
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_sessions_recordedAt ON swing_sessions(recordedAt)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE swing_sessions ADD COLUMN impactDetected INTEGER NOT NULL DEFAULT 1',
          );
        }
      },
    );
  }

  Future<SwingSession> insertSession(SwingSession session) async {
    final db = await database;
    final id = await db.insert('swing_sessions', _toRow(session));
    return session.copyWith(id: id);
  }

  Future<List<SwingSession>> getAllSessions() async {
    final db = await database;
    final rows = await db.query('swing_sessions', orderBy: 'recordedAt DESC');
    return rows.map(_fromRow).toList();
  }

  Future<SwingSession?> getSessionById(int id) async {
    final db = await database;
    final rows = await db.query(
      'swing_sessions',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return _fromRow(rows.first);
  }

  Future<void> deleteSession(int id) async {
    final db = await database;
    await db.delete('swing_sessions', where: 'id = ?', whereArgs: [id]);
  }

  Map<String, dynamic> _toRow(SwingSession s) => {
    'videoPath': s.videoPath.value,
    'recordedAt': s.recordedAt.toIso8601String(),
    'durationMs': s.duration.milliseconds,
    'targetFps': s.targetFps.value,
    'note': s.note,
    'impactDetected': s.impactDetected ? 1 : 0,
  };

  SwingSession _fromRow(Map<String, dynamic> row) => SwingSession(
    id: row['id'] as int,
    videoPath: VideoPath(row['videoPath'] as String),
    recordedAt: DateTime.parse(row['recordedAt'] as String),
    duration: SwingDuration(row['durationMs'] as int),
    targetFps: Fps(row['targetFps'] as int),
    note: row['note'] as String?,
    impactDetected: (row['impactDetected'] as int) != 0,
  );
}
