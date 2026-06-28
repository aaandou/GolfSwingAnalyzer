import '../exceptions/invalid_value_object_exception.dart';

/// スイング動画ファイルの保存先パス。
class VideoPath {
  final String value;

  VideoPath(this.value) {
    if (value.isEmpty) {
      throw InvalidValueObjectException('videoPath must not be empty');
    }
  }

  @override
  bool operator ==(Object other) => other is VideoPath && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
