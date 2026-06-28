import 'package:flutter_test/flutter_test.dart';
import 'package:golf_swing_analyzer/domain/value_objects/hit_angle.dart';

void main() {
  group('HitAngle', () {
    test('label identifies the attribute', () {
      expect(HitAngle(12.3).label, 'ヒット角');
    });

    test('positive degrees are shown as 右 (right)', () {
      expect(HitAngle(12.34).displayValue, '右12.3°');
    });

    test('negative degrees are shown as 左 (left) with a positive magnitude', () {
      expect(HitAngle(-5).displayValue, '左5.0°');
    });

    test('zero degrees is shown as square, with no direction', () {
      expect(HitAngle(0).displayValue, '0.0°（スクエア）');
    });

    test('equal degrees are equal', () {
      expect(HitAngle(12.3), HitAngle(12.3));
      expect(HitAngle(12.3), isNot(HitAngle(12.4)));
    });
  });
}
