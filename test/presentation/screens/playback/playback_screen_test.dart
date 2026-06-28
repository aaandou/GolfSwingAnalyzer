import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:golf_swing_analyzer/application/dtos/playback_args.dart';
import 'package:golf_swing_analyzer/application/use_cases/swing_session/delete_swing_session_use_case.dart';
import 'package:golf_swing_analyzer/data/services/video_storage_service.dart';
import 'package:golf_swing_analyzer/domain/entities/swing_session.dart';
import 'package:golf_swing_analyzer/domain/repositories/i_swing_session_repository.dart';
import 'package:golf_swing_analyzer/domain/value_objects/fps.dart';
import 'package:golf_swing_analyzer/domain/value_objects/swing_duration.dart';
import 'package:golf_swing_analyzer/domain/value_objects/video_path.dart';
import 'package:golf_swing_analyzer/presentation/providers/providers.dart';
import 'package:golf_swing_analyzer/presentation/screens/playback/playback_screen.dart';

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

class _FakeDeleteSwingSessionUseCase extends DeleteSwingSessionUseCase {
  _FakeDeleteSwingSessionUseCase() : super(_UnusedRepository());
  int? deletedId;

  @override
  Future<void> execute(int id) async {
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
  id: 7,
  videoPath: VideoPath('/swings/swing_7.mp4'),
  recordedAt: DateTime(2026, 6, 28),
  duration: SwingDuration(400),
  targetFps: Fps(60),
);

Future<void> _pumpPlaybackScreen(
  WidgetTester tester, {
  required bool isFreshRecording,
  required _FakeDeleteSwingSessionUseCase deleteUseCase,
  required _FakeVideoStorageService videoStorage,
}) async {
  final args = PlaybackArgs(
    session: _buildSession(),
    isFreshRecording: isFreshRecording,
  );
  final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (_, _) => const Scaffold(body: Text('home')),
      ),
      GoRoute(
        path: '/playback',
        builder: (_, _) => PlaybackScreen(args: args),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        deleteSwingSessionUseCaseProvider.overrideWithValue(deleteUseCase),
        videoStorageServiceProvider.overrideWithValue(videoStorage),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  router.push('/playback', extra: args);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  testWidgets('AppBar shows a 削除 action instead of a bottom button', (
    tester,
  ) async {
    await _pumpPlaybackScreen(
      tester,
      isFreshRecording: false,
      deleteUseCase: _FakeDeleteSwingSessionUseCase(),
      videoStorage: _FakeVideoStorageService(),
    );

    expect(find.widgetWithText(AppBar, 'スイングレビュー'), findsOneWidget);
    expect(find.widgetWithText(TextButton, '削除'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, '削除'), findsNothing);
  });

  testWidgets('tapping 削除 shows a confirmation dialog before deleting', (
    tester,
  ) async {
    final deleteUseCase = _FakeDeleteSwingSessionUseCase();
    await _pumpPlaybackScreen(
      tester,
      isFreshRecording: false,
      deleteUseCase: deleteUseCase,
      videoStorage: _FakeVideoStorageService(),
    );

    await tester.tap(find.widgetWithText(TextButton, '削除'));
    await tester.pump();

    expect(find.text('このスイングを削除しますか？元に戻せません。'), findsOneWidget);
    expect(deleteUseCase.deletedId, isNull);
  });

  testWidgets('canceling the dialog does not delete anything', (
    tester,
  ) async {
    final deleteUseCase = _FakeDeleteSwingSessionUseCase();
    await _pumpPlaybackScreen(
      tester,
      isFreshRecording: false,
      deleteUseCase: deleteUseCase,
      videoStorage: _FakeVideoStorageService(),
    );

    await tester.tap(find.widgetWithText(TextButton, '削除'));
    await tester.pump();
    await tester.tap(find.widgetWithText(TextButton, 'キャンセル'));
    await tester.pump();

    expect(find.text('このスイングを削除しますか？元に戻せません。'), findsNothing);
    expect(deleteUseCase.deletedId, isNull);
  });

  testWidgets('confirming the dialog deletes the saved session', (
    tester,
  ) async {
    final deleteUseCase = _FakeDeleteSwingSessionUseCase();
    await _pumpPlaybackScreen(
      tester,
      isFreshRecording: false,
      deleteUseCase: deleteUseCase,
      videoStorage: _FakeVideoStorageService(),
    );

    await tester.tap(find.widgetWithText(TextButton, '削除'));
    await tester.pump();
    await tester.tap(find.widgetWithText(TextButton, '削除').last);
    await tester.pump();
    await tester.pump();

    expect(deleteUseCase.deletedId, 7);
    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('confirming the dialog for a fresh recording discards the file', (
    tester,
  ) async {
    final videoStorage = _FakeVideoStorageService();
    await _pumpPlaybackScreen(
      tester,
      isFreshRecording: true,
      deleteUseCase: _FakeDeleteSwingSessionUseCase(),
      videoStorage: videoStorage,
    );

    await tester.tap(find.widgetWithText(TextButton, '削除'));
    await tester.pump();

    expect(find.text('この録画を削除しますか？'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, '削除').last);
    await tester.pump();
    await tester.pump();

    expect(videoStorage.deletedPath, '/swings/swing_7.mp4');
  });
}
