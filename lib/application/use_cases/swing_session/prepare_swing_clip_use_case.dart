import '../../../data/services/impact_detection_service.dart';
import '../../../data/services/video_storage_service.dart';
import '../../../data/services/video_trim_service.dart';
import '../../../domain/entities/swing_session.dart';
import '../../../domain/value_objects/swing_duration.dart';
import '../../../domain/value_objects/video_path.dart';

/// 撮影直後のドラフトSwingSessionを受け取り、インパクト（ボールが消えた瞬間）を検出できた場合は
/// その前後0.2秒だけを残した動画にトリミングしたSwingSessionを返す。検出できなかった場合は
/// 元の動画のまま `impactDetected: false` を付けて返す。
class PrepareSwingClipUseCase {
  static const _clipMargin = Duration(milliseconds: 200);

  final ImpactDetectionService _impactDetection;
  final VideoTrimService _videoTrim;
  final VideoStorageService _videoStorage;

  PrepareSwingClipUseCase(
    this._impactDetection,
    this._videoTrim,
    this._videoStorage,
  );

  Future<SwingSession> execute(SwingSession draft) async {
    final totalDuration = Duration(milliseconds: draft.duration.milliseconds);
    final impactAt = await _impactDetection.detectImpactTimestamp(
      draft.videoPath.value,
      totalDuration,
    );
    if (impactAt == null) {
      return draft.copyWith(impactDetected: false);
    }

    var start = impactAt - _clipMargin;
    if (start.isNegative) start = Duration.zero;
    var end = impactAt + _clipMargin;
    if (end > totalDuration) end = totalDuration;

    final trimmedPath = await _videoTrim.trim(
      draft.videoPath.value,
      start,
      end,
    );
    await _videoStorage.delete(draft.videoPath.value);

    return draft.copyWith(
      videoPath: VideoPath(trimmedPath),
      duration: SwingDuration((end - start).inMilliseconds),
      impactDetected: true,
    );
  }
}
