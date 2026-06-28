import '../../data/services/club_face_angle_detection_service.dart';
import '../../domain/value_objects/hit_angle.dart';
import '../../domain/value_objects/swing_analysis_attribute.dart';
import 'swing_analyzer.dart';

class HitAngleAnalyzer implements SwingAnalyzer {
  final ClubFaceAngleDetectionService _detection;

  HitAngleAnalyzer(this._detection);

  @override
  Future<SwingAnalysisAttribute?> analyze(
    String videoPath,
    Duration impactAt,
  ) async {
    final degrees = await _detection.detectAngle(videoPath, impactAt);
    return degrees == null ? null : HitAngle(degrees);
  }
}
