import 'swing_analysis_attribute.dart';

/// インパクト時のクラブフェース角度（水平からの度数）の推定値。
///
/// 画像解析によるbest-effortな推定値のため、不変条件（範囲チェック等）は設けない。
///
/// 右打ちのゴルファーを正面（ゴルファーが画像の上部）から撮影する想定のカメラ配置を前提に、
/// 符号を「右に何度／左に何度」という向きに変換して表示する。`degrees > 0` を右、
/// `degrees < 0` を左としているが、実機での向きの検証はこの表示変更のみで完了していないため、
/// 実際の映像で左右が逆だった場合はこの符号の対応（`degrees > 0` の判定）を反転すること。
class HitAngle implements SwingAnalysisAttribute {
  final double degrees;

  HitAngle(this.degrees);

  @override
  String get label => 'ヒット角';

  @override
  String get displayValue {
    final magnitude = degrees.abs().toStringAsFixed(1);
    if (degrees == 0) return '0.0°（スクエア）';
    final direction = degrees > 0 ? '右' : '左';
    return '$direction$magnitude°';
  }

  @override
  bool operator ==(Object other) => other is HitAngle && other.degrees == degrees;

  @override
  int get hashCode => degrees.hashCode;

  @override
  String toString() => displayValue;
}
