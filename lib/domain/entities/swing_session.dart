import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/fps.dart';
import '../value_objects/swing_duration.dart';
import '../value_objects/video_path.dart';

part 'swing_session.freezed.dart';

@freezed
abstract class SwingSession with _$SwingSession {
  const SwingSession._();

  const factory SwingSession({
    required int id,
    required VideoPath videoPath,
    required DateTime recordedAt,
    required SwingDuration duration,
    required Fps targetFps,
    String? note,
    @Default(true) bool impactDetected,
  }) = _SwingSession;

  String get durationLabel => duration.label;
}
