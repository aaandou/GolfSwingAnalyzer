import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golf_swing_analyzer/application/use_cases/swing_session/delete_swing_session_use_case.dart';
import 'package:golf_swing_analyzer/domain/entities/swing_session.dart';
import 'package:golf_swing_analyzer/domain/repositories/i_swing_session_repository.dart';
import 'package:golf_swing_analyzer/domain/value_objects/fps.dart';
import 'package:golf_swing_analyzer/domain/value_objects/swing_duration.dart';
import 'package:golf_swing_analyzer/domain/value_objects/video_path.dart';
import 'package:golf_swing_analyzer/presentation/providers/providers.dart';
import 'package:golf_swing_analyzer/presentation/screens/history/history_screen.dart';

class _UnusedRepository implements ISwingSessionRepository {
  @override
  Future<void> delete(int id) => throw UnimplementedError();
  @override
  Future<List<SwingSession>> getAll() => throw UnimplementedError();
  @override
  Future<SwingSession?> getById(int id) => throw UnimplementedError();
  @override
  Future<SwingSession> save(SwingSession session) => throw UnimplementedError();
}

/// 削除を呼ぶと[_sessions]からも取り除く。これにより、テスト用にoverrideした
/// allSwingSessionsProviderをinvalidateで再取得した際も、本物のRepository同様に
/// 削除済みセッションが本当に除外された状態を再現できる。
class _FakeDeleteSwingSessionUseCase extends DeleteSwingSessionUseCase {
  _FakeDeleteSwingSessionUseCase(this._sessions) : super(_UnusedRepository());
  final List<SwingSession> _sessions;
  int? deletedId;

  @override
  Future<void> execute(int id) async {
    deletedId = id;
    _sessions.removeWhere((session) => session.id == id);
  }
}

SwingSession _buildSession(int id) => SwingSession(
  id: id,
  videoPath: VideoPath('/swings/swing_$id.mp4'),
  recordedAt: DateTime(2026, 6, 28, 9, id),
  duration: SwingDuration(400),
  targetFps: Fps(60),
);

void main() {
  testWidgets(
    'dismissing a card deletes it immediately without leaving a stale '
    'Dismissible in the tree',
    (tester) async {
      final sessions = [_buildSession(1), _buildSession(2)];
      final deleteUseCase = _FakeDeleteSwingSessionUseCase(sessions);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            allSwingSessionsProvider.overrideWith(
              (ref) async => List.of(sessions),
            ),
            deleteSwingSessionUseCaseProvider.overrideWithValue(
              deleteUseCase,
            ),
          ],
          child: const MaterialApp(home: HistoryScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Dismissible), findsNWidgets(2));

      await tester.drag(find.byType(Dismissible).first, const Offset(-500, 0));
      await tester.pumpAndSettle();

      // A stale Dismissible still in the tree after onDismissed throws a
      // FlutterError synchronously during the next build; takeException()
      // surfaces it instead of letting the test framework swallow it.
      expect(tester.takeException(), isNull);
      expect(find.byType(Dismissible), findsOneWidget);
      expect(deleteUseCase.deletedId, 1);
    },
  );
}
