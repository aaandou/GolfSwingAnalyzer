import 'package:flutter_test/flutter_test.dart';
import 'package:golf_swing_analyzer/application/swing_analyzers/swing_analyzer.dart';
import 'package:golf_swing_analyzer/application/use_cases/swing_session/prepare_swing_session_use_case.dart';
import 'package:golf_swing_analyzer/data/services/impact_detection_service.dart';
import 'package:golf_swing_analyzer/data/services/video_storage_service.dart';
import 'package:golf_swing_analyzer/data/services/video_trim_service.dart';
import 'package:golf_swing_analyzer/domain/entities/swing_session.dart';
import 'package:golf_swing_analyzer/domain/value_objects/fps.dart';
import 'package:golf_swing_analyzer/domain/value_objects/hit_angle.dart';
import 'package:golf_swing_analyzer/domain/value_objects/swing_analysis_attribute.dart';
import 'package:golf_swing_analyzer/domain/value_objects/swing_duration.dart';
import 'package:golf_swing_analyzer/domain/value_objects/video_path.dart';

class _FakeImpactDetectionService extends ImpactDetectionService {
  _FakeImpactDetectionService(this._result);
  final Duration? _result;

  @override
  Future<Duration?> detectImpactTimestamp(
    String videoPath,
    Duration totalDuration,
  ) async => _result;
}

class _FakeVideoTrimService extends VideoTrimService {
  String? calledVideoPath;
  Duration? calledStart;
  Duration? calledEnd;
  int callCount = 0;

  @override
  Future<String> trim(String videoPath, Duration start, Duration end) async {
    callCount++;
    calledVideoPath = videoPath;
    calledStart = start;
    calledEnd = end;
    return '/swings/trimmed.mp4';
  }
}

class _FakeVideoStorageService extends VideoStorageService {
  String? deletedPath;
  int deleteCallCount = 0;

  @override
  Future<void> delete(String videoPath) async {
    deleteCallCount++;
    deletedPath = videoPath;
  }
}

class _FakeSwingAnalyzer implements SwingAnalyzer {
  _FakeSwingAnalyzer(this._result);
  final SwingAnalysisAttribute? _result;
  String? calledVideoPath;
  Duration? calledImpactAt;
  int callCount = 0;

  @override
  Future<SwingAnalysisAttribute?> analyze(
    String videoPath,
    Duration impactAt,
  ) async {
    callCount++;
    calledVideoPath = videoPath;
    calledImpactAt = impactAt;
    return _result;
  }
}

SwingSession _buildDraft() => SwingSession(
  id: 0,
  videoPath: VideoPath('/swings/original.mp4'),
  recordedAt: DateTime(2026, 6, 28),
  duration: SwingDuration(10000),
  targetFps: Fps(60),
);

void main() {
  group('PrepareSwingSessionUseCase', () {
    test('trims around the detected impact and marks it detected', () async {
      final trim = _FakeVideoTrimService();
      final storage = _FakeVideoStorageService();
      final useCase = PrepareSwingSessionUseCase(
        _FakeImpactDetectionService(const Duration(seconds: 5)),
        trim,
        storage,
        [],
      );

      final result = await useCase.execute(_buildDraft());

      expect(result.impactDetected, isTrue);
      expect(result.videoPath, VideoPath('/swings/trimmed.mp4'));
      expect(result.duration, SwingDuration(400));
      expect(trim.callCount, 1);
      expect(trim.calledVideoPath, '/swings/original.mp4');
      expect(trim.calledStart, const Duration(seconds: 4, milliseconds: 800));
      expect(trim.calledEnd, const Duration(seconds: 5, milliseconds: 200));
      expect(storage.deleteCallCount, 1);
      expect(storage.deletedPath, '/swings/original.mp4');
    });

    test(
      'falls back to the original clip when impact is not detected',
      () async {
        final trim = _FakeVideoTrimService();
        final storage = _FakeVideoStorageService();
        final analyzer = _FakeSwingAnalyzer(HitAngle(12.3));
        final useCase = PrepareSwingSessionUseCase(
          _FakeImpactDetectionService(null),
          trim,
          storage,
          [analyzer],
        );
        final draft = _buildDraft();

        final result = await useCase.execute(draft);

        expect(result.impactDetected, isFalse);
        expect(result.videoPath, draft.videoPath);
        expect(result.duration, draft.duration);
        expect(result.analysisAttributes, isEmpty);
        expect(trim.callCount, 0);
        expect(storage.deleteCallCount, 0);
        expect(analyzer.callCount, 0);
      },
    );

    test('clamps the trim window to the start of the video', () async {
      final trim = _FakeVideoTrimService();
      final useCase = PrepareSwingSessionUseCase(
        _FakeImpactDetectionService(const Duration(milliseconds: 100)),
        trim,
        _FakeVideoStorageService(),
        [],
      );

      await useCase.execute(_buildDraft());

      expect(trim.calledStart, Duration.zero);
      expect(trim.calledEnd, const Duration(milliseconds: 300));
    });

    test(
      'runs registered analyzers against the original video at the impact time',
      () async {
        final analyzer = _FakeSwingAnalyzer(HitAngle(8.5));
        final useCase = PrepareSwingSessionUseCase(
          _FakeImpactDetectionService(const Duration(seconds: 5)),
          _FakeVideoTrimService(),
          _FakeVideoStorageService(),
          [analyzer],
        );

        final result = await useCase.execute(_buildDraft());

        expect(analyzer.callCount, 1);
        expect(analyzer.calledVideoPath, '/swings/original.mp4');
        expect(analyzer.calledImpactAt, const Duration(seconds: 5));
        expect(result.analysisAttributes, [HitAngle(8.5)]);
      },
    );

    test('omits an analyzer result that comes back null', () async {
      final analyzer = _FakeSwingAnalyzer(null);
      final useCase = PrepareSwingSessionUseCase(
        _FakeImpactDetectionService(const Duration(seconds: 5)),
        _FakeVideoTrimService(),
        _FakeVideoStorageService(),
        [analyzer],
      );

      final result = await useCase.execute(_buildDraft());

      expect(result.analysisAttributes, isEmpty);
    });
  });
}
