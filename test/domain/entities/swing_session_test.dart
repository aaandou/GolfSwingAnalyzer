import 'package:flutter_test/flutter_test.dart';
import 'package:golf_swing_analyzer/domain/entities/swing_session.dart';
import 'package:golf_swing_analyzer/domain/value_objects/fps.dart';
import 'package:golf_swing_analyzer/domain/value_objects/swing_duration.dart';
import 'package:golf_swing_analyzer/domain/value_objects/video_path.dart';

SwingSession _buildSession() => SwingSession(
  id: 1,
  videoPath: VideoPath('/swings/swing_1.mp4'),
  recordedAt: DateTime(2026, 6, 28, 9, 42),
  duration: SwingDuration(400),
  targetFps: Fps(60),
);

void main() {
  group('SwingSession', () {
    test('durationLabel delegates to SwingDuration.label', () {
      expect(_buildSession().durationLabel, '00:00.4');
    });

    test('copyWith replaces only the given fields', () {
      final original = _buildSession();
      final updated = original.copyWith(impactDetected: false);

      expect(updated.impactDetected, isFalse);
      expect(updated.videoPath, original.videoPath);
      expect(updated.duration, original.duration);
      expect(updated.targetFps, original.targetFps);
    });

    test('equal field values produce equal entities', () {
      expect(_buildSession(), _buildSession());
    });
  });
}
