import 'package:flutter_test/flutter_test.dart';
import 'package:golf_swing_analyzer/domain/exceptions/invalid_value_object_exception.dart';
import 'package:golf_swing_analyzer/domain/value_objects/video_path.dart';

void main() {
  group('VideoPath', () {
    test('accepts a non-empty path', () {
      final path = VideoPath('/swings/swing_1.mp4');
      expect(path.value, '/swings/swing_1.mp4');
    });

    test('rejects an empty path', () {
      expect(() => VideoPath(''), throwsA(isA<InvalidValueObjectException>()));
    });

    test('equal values are equal', () {
      expect(VideoPath('/a.mp4'), VideoPath('/a.mp4'));
      expect(VideoPath('/a.mp4'), isNot(VideoPath('/b.mp4')));
    });
  });
}
