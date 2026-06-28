import '../exceptions/invalid_value_object_exception.dart';

/// スイング動画の再生時間。
class SwingDuration {
  final int milliseconds;

  SwingDuration(this.milliseconds) {
    if (milliseconds < 0) {
      throw InvalidValueObjectException(
        'duration milliseconds must not be negative',
      );
    }
  }

  /// 100ミリ秒（0.1秒）単位で表示する mm:ss.t 形式のラベル。
  String get label {
    final totalTenths = (milliseconds / 100).round();
    final totalSeconds = totalTenths ~/ 10;
    final tenths = totalTenths % 10;
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}.$tenths';
  }

  @override
  bool operator ==(Object other) =>
      other is SwingDuration && other.milliseconds == milliseconds;

  @override
  int get hashCode => milliseconds.hashCode;

  @override
  String toString() => label;
}
