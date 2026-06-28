import 'package:image/image.dart' as img;
import 'package:video_thumbnail/video_thumbnail.dart';

/// [OverheadAlignmentGuide] のクロスヘアと同じ位置（プレビュー中央、短辺の12%の円）を
/// ROIとして、フレーム間の色差からボールが消えた（インパクトの）タイミングをbest-effortで推定する。
///
/// 実機ではネイティブのサムネイル抽出1回あたり300〜400ms程度かかるため、全区間を33ms間隔で
/// 走査すると10秒の動画で100秒以上かかってしまう。そのため粗い間隔(_coarseIntervalMs)で
/// 候補区間を見つけたあと、その区間だけ細かい間隔(_fineIntervalMs)で再走査して精度を確保する。
class ImpactDetectionService {
  static const _coarseIntervalMs = 300;
  static const _fineIntervalMs = 33;
  static const _roiFraction = 0.12;
  static const _diffThreshold = 30.0;
  static const _requiredConsecutiveHits = 2;

  Future<Duration?> detectImpactTimestamp(
    String videoPath,
    Duration totalDuration,
  ) async {
    final baseline = await _sampleRoiColor(videoPath, 0);
    if (baseline == null) return null;

    final totalMs = totalDuration.inMilliseconds;
    final coarseHit = await _scan(
      videoPath,
      baseline,
      start: _coarseIntervalMs,
      end: totalMs,
      step: _coarseIntervalMs,
      requireConsecutive: true,
    );
    if (coarseHit == null) return null;

    final refineStart = (coarseHit - _coarseIntervalMs).clamp(0, coarseHit);
    final fineHit = await _scan(
      videoPath,
      baseline,
      start: refineStart,
      end: coarseHit,
      step: _fineIntervalMs,
      requireConsecutive: false,
    );
    return Duration(milliseconds: fineHit ?? coarseHit);
  }

  Future<int?> _scan(
    String videoPath,
    double baseline, {
    required int start,
    required int end,
    required int step,
    required bool requireConsecutive,
  }) async {
    int consecutiveHits = 0;
    int? candidateMs;

    for (var t = start; t <= end; t += step) {
      final roiColor = await _sampleRoiColor(videoPath, t);
      if (roiColor == null) continue;

      final diff = (roiColor - baseline).abs();
      if (diff > _diffThreshold) {
        if (!requireConsecutive) return t;
        if (consecutiveHits == 0) candidateMs = t;
        consecutiveHits++;
        if (consecutiveHits >= _requiredConsecutiveHits) return candidateMs;
      } else {
        consecutiveHits = 0;
        candidateMs = null;
      }
    }
    return null;
  }

  Future<double?> _sampleRoiColor(String videoPath, int timeMs) async {
    final bytes = await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      timeMs: timeMs,
      quality: 50,
      maxWidth: 240,
    );
    if (bytes == null) return null;
    final image = img.decodeImage(bytes);
    if (image == null) return null;

    final side = image.width < image.height ? image.width : image.height;
    final roiSize = (side * _roiFraction).round();
    final cx = image.width ~/ 2;
    final cy = image.height ~/ 2;
    final left = (cx - roiSize ~/ 2).clamp(0, image.width - 1);
    final top = (cy - roiSize ~/ 2).clamp(0, image.height - 1);
    final right = (left + roiSize).clamp(0, image.width);
    final bottom = (top + roiSize).clamp(0, image.height);

    double sum = 0;
    var count = 0;
    for (var y = top; y < bottom; y++) {
      for (var x = left; x < right; x++) {
        final pixel = image.getPixel(x, y);
        sum += (pixel.r + pixel.g + pixel.b) / 3;
        count++;
      }
    }
    if (count == 0) return null;
    return sum / count;
  }
}
