import '../../../data/services/impact_detection_service.dart';
import '../../../data/services/video_storage_service.dart';
import '../../../data/services/video_trim_service.dart';
import '../../../domain/entities/swing_session.dart';
import '../../../domain/value_objects/swing_analysis_attribute.dart';
import '../../../domain/value_objects/swing_duration.dart';
import '../../../domain/value_objects/video_path.dart';
import '../../swing_analyzers/swing_analyzer.dart';

/// 撮影直後のドラフトSwingSessionを受け取り、インパクト（ボールが消えた瞬間）を検出できた場合は
/// その前後0.2秒だけを残した動画にトリミングし、登録された [SwingAnalyzer] 群でスイングを解析した
/// SwingSessionを返す。検出できなかった場合はトリミング・解析のいずれも行わず、元の動画のまま
/// `impactDetected: false` を付けて返す（解析はインパクト時刻に依存するため）。
class PrepareSwingSessionUseCase {
  static const _clipMargin = Duration(milliseconds: 200);

  final ImpactDetectionService _impactDetection;
  final VideoTrimService _videoTrim;
  final VideoStorageService _videoStorage;
  final List<SwingAnalyzer> _analyzers;

  PrepareSwingSessionUseCase(
    this._impactDetection,
    this._videoTrim,
    this._videoStorage,
    this._analyzers,
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

    final attributes = await _analyzeAll(draft.videoPath.value, impactAt);

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
      analysisAttributes: attributes,
    );
  }

  Future<List<SwingAnalysisAttribute>> _analyzeAll(
    String videoPath,
    Duration impactAt,
  ) async {
    final attributes = <SwingAnalysisAttribute>[];
    for (final analyzer in _analyzers) {
      final attribute = await analyzer.analyze(videoPath, impactAt);
      if (attribute != null) attributes.add(attribute);
    }
    return attributes;
  }
}
