import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/swing_session.dart';

part 'playback_args.freezed.dart';

@freezed
abstract class PlaybackArgs with _$PlaybackArgs {
  const factory PlaybackArgs({
    required SwingSession session,
    required bool isFreshRecording,
  }) = _PlaybackArgs;
}
