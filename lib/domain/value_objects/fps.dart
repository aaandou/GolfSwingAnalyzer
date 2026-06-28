import '../exceptions/invalid_value_object_exception.dart';

/// 撮影・再生の目標フレームレート。
class Fps {
  final int value;

  Fps(this.value) {
    if (value <= 0) {
      throw InvalidValueObjectException('fps must be greater than zero');
    }
  }

  @override
  bool operator ==(Object other) => other is Fps && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}
