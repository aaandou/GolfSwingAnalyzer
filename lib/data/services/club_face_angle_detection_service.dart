import 'dart:math' as math;

import 'package:image/image.dart' as img;
import 'package:video_thumbnail/video_thumbnail.dart';

/// インパクト直前のフレームから、クラブフェースの縁（エッジ）の向きを
/// Sobelオペレータで推定し、水平からの角度をbest-effortで算出する。
///
/// [ImpactDetectionService] と同様に精度を保証しない画像解析ヒューリスティック。
/// 十分な強さのエッジが見つからない場合はnullを返す。
class ClubFaceAngleDetectionService {
  static const _preImpactOffsetMs = 16;
  static const _roiFraction = 0.25;
  static const _gradientMagnitudeThreshold = 40.0;
  static const _minVotingMass = 50.0;
  static const _angleBinCount = 180;

  Future<double?> detectAngle(String videoPath, Duration impactAt) async {
    final sampleMs = (impactAt.inMilliseconds - _preImpactOffsetMs).clamp(
      0,
      impactAt.inMilliseconds,
    );
    final cropped = await _sampleCroppedGrayscale(videoPath, sampleMs);
    if (cropped == null) return null;

    final votes = List<double>.filled(_angleBinCount, 0);
    for (var y = 1; y < cropped.height - 1; y++) {
      for (var x = 1; x < cropped.width - 1; x++) {
        final gx = _sobelX(cropped, x, y);
        final gy = _sobelY(cropped, x, y);
        final magnitude = math.sqrt(gx * gx + gy * gy);
        if (magnitude <= _gradientMagnitudeThreshold) continue;

        final gradientAngleDeg = math.atan2(gy, gx) * 180 / math.pi;
        final bin = _normalizeBin(gradientAngleDeg);
        votes[bin] += magnitude;
      }
    }

    var peakBin = 0;
    for (var i = 1; i < votes.length; i++) {
      if (votes[i] > votes[peakBin]) peakBin = i;
    }
    if (votes[peakBin] < _minVotingMass) return null;

    final edgeAngle = peakBin - 90;
    return edgeAngle.toDouble();
  }

  int _normalizeBin(double gradientAngleDeg) {
    final normalized = ((gradientAngleDeg % 180) + 180) % 180;
    return normalized.floor().clamp(0, _angleBinCount - 1);
  }

  double _luminance(img.Image image, int x, int y) {
    final pixel = image.getPixel(x, y);
    return pixel.r.toDouble();
  }

  double _sobelX(img.Image image, int x, int y) {
    return -_luminance(image, x - 1, y - 1) +
        _luminance(image, x + 1, y - 1) +
        -2 * _luminance(image, x - 1, y) +
        2 * _luminance(image, x + 1, y) +
        -_luminance(image, x - 1, y + 1) +
        _luminance(image, x + 1, y + 1);
  }

  double _sobelY(img.Image image, int x, int y) {
    return -_luminance(image, x - 1, y - 1) +
        -2 * _luminance(image, x, y - 1) +
        -_luminance(image, x + 1, y - 1) +
        _luminance(image, x - 1, y + 1) +
        2 * _luminance(image, x, y + 1) +
        _luminance(image, x + 1, y + 1);
  }

  Future<img.Image?> _sampleCroppedGrayscale(
    String videoPath,
    int timeMs,
  ) async {
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
    final width = roiSize.clamp(1, image.width - left);
    final height = roiSize.clamp(1, image.height - top);

    final cropped = img.copyCrop(
      image,
      x: left,
      y: top,
      width: width,
      height: height,
    );
    return img.grayscale(cropped);
  }
}
