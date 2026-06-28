import '../../domain/value_objects/swing_analysis_attribute.dart';

/// インパクト時刻が分かっている動画から、スイングの解析結果1件を算出する。
///
/// 新しい解析を追加する際は、この interface の実装を1つ追加し、
/// [PrepareSwingSessionUseCase] に渡す analyzer のリストに登録するだけでよい。
abstract interface class SwingAnalyzer {
  Future<SwingAnalysisAttribute?> analyze(String videoPath, Duration impactAt);
}
