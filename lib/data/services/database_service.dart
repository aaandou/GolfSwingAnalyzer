import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/entities/swing_session.dart';
import '../../domain/value_objects/fps.dart';
import '../../domain/value_objects/hit_angle.dart';
import '../../domain/value_objects/swing_analysis_attribute.dart';
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
      version: 3,
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
        await _createAnalysisAttributesTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE swing_sessions ADD COLUMN impactDetected INTEGER NOT NULL DEFAULT 1',
          );
        }
        if (oldVersion < 3) {
          await _createAnalysisAttributesTable(db);
        }
      },
    );
  }

  Future<void> _createAnalysisAttributesTable(DatabaseExecutor db) async {
    await db.execute('''
      CREATE TABLE swing_analysis_attributes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        swingSessionId INTEGER NOT NULL,
        type TEXT NOT NULL,
        value TEXT NOT NULL
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_attributes_swingSessionId ON swing_analysis_attributes(swingSessionId)',
    );
  }

  Future<SwingSession> insertSession(SwingSession session) async {
    final db = await database;
    final id = await db.insert('swing_sessions', _toRow(session));
    await _insertAttributes(db, id, session.analysisAttributes);
    return session.copyWith(id: id);
  }

  Future<List<SwingSession>> getAllSessions() async {
    final db = await database;
    final rows = await db.query('swing_sessions', orderBy: 'recordedAt DESC');
    if (rows.isEmpty) return [];

    final ids = rows.map((row) => row['id'] as int).toList();
    final attributesBySessionId = await _getAttributesForSessions(db, ids);
    return rows
        .map(
          (row) => _fromRow(
            row,
            attributesBySessionId[row['id'] as int] ?? const [],
          ),
        )
        .toList();
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
    final attributesBySessionId = await _getAttributesForSessions(db, [id]);
    return _fromRow(rows.first, attributesBySessionId[id] ?? const []);
  }

  Future<void> deleteSession(int id) async {
    final db = await database;
    await db.delete(
      'swing_analysis_attributes',
      where: 'swingSessionId = ?',
      whereArgs: [id],
    );
    await db.delete('swing_sessions', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _insertAttributes(
    DatabaseExecutor db,
    int swingSessionId,
    List<SwingAnalysisAttribute> attributes,
  ) async {
    for (final attribute in attributes) {
      final row = _attributeToRow(swingSessionId, attribute);
      if (row != null) {
        await db.insert('swing_analysis_attributes', row);
      }
    }
  }

  Future<Map<int, List<SwingAnalysisAttribute>>> _getAttributesForSessions(
    DatabaseExecutor db,
    List<int> swingSessionIds,
  ) async {
    if (swingSessionIds.isEmpty) return {};
    final placeholders = List.filled(swingSessionIds.length, '?').join(',');
    final rows = await db.query(
      'swing_analysis_attributes',
      where: 'swingSessionId IN ($placeholders)',
      whereArgs: swingSessionIds,
    );

    final result = <int, List<SwingAnalysisAttribute>>{};
    for (final row in rows) {
      final attribute = _attributeFromRow(row);
      if (attribute == null) continue;
      final sessionId = row['swingSessionId'] as int;
      result.putIfAbsent(sessionId, () => []).add(attribute);
    }
    return result;
  }

  /// 新しい解析属性（[SwingAnalysisAttribute]の実装）を追加する際は、ここに1ケース追加する。
  Map<String, dynamic>? _attributeToRow(
    int swingSessionId,
    SwingAnalysisAttribute attribute,
  ) {
    if (attribute is HitAngle) {
      return {
        'swingSessionId': swingSessionId,
        'type': 'hitAngle',
        'value': attribute.degrees.toString(),
      };
    }
    return null;
  }

  SwingAnalysisAttribute? _attributeFromRow(Map<String, dynamic> row) {
    final type = row['type'] as String;
    final value = row['value'] as String;
    switch (type) {
      case 'hitAngle':
        return HitAngle(double.parse(value));
      default:
        return null;
    }
  }

  Map<String, dynamic> _toRow(SwingSession s) => {
    'videoPath': s.videoPath.value,
    'recordedAt': s.recordedAt.toIso8601String(),
    'durationMs': s.duration.milliseconds,
    'targetFps': s.targetFps.value,
    'note': s.note,
    'impactDetected': s.impactDetected ? 1 : 0,
  };

  SwingSession _fromRow(
    Map<String, dynamic> row,
    List<SwingAnalysisAttribute> attributes,
  ) => SwingSession(
    id: row['id'] as int,
    videoPath: VideoPath(row['videoPath'] as String),
    recordedAt: DateTime.parse(row['recordedAt'] as String),
    duration: SwingDuration(row['durationMs'] as int),
    targetFps: Fps(row['targetFps'] as int),
    note: row['note'] as String?,
    impactDetected: (row['impactDetected'] as int) != 0,
    analysisAttributes: attributes,
  );
}
