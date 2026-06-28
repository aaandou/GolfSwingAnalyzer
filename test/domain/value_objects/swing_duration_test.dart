import 'package:flutter_test/flutter_test.dart';
import 'package:golf_swing_analyzer/domain/exceptions/invalid_value_object_exception.dart';
import 'package:golf_swing_analyzer/domain/value_objects/swing_duration.dart';

void main() {
  group('SwingDuration', () {
    test('rejects a negative value', () {
      expect(
        () => SwingDuration(-1),
        throwsA(isA<InvalidValueObjectException>()),
      );
    });

    test('accepts zero', () {
      expect(SwingDuration(0).milliseconds, 0);
    });

    test('equal values are equal', () {
      expect(SwingDuration(400), SwingDuration(400));
      expect(SwingDuration(400), isNot(SwingDuration(500)));
    });

    // 実機検証(2026/06/28)で確認済みの表示値をそのまま固定化する。
    group('label formats mm:ss.t (100ms precision)', () {
      const cases = {
        400: '00:00.4',
        3500: '00:03.5',
        19500: '00:19.5',
        0: '00:00.0',
        60000: '01:00.0',
      };

      for (final entry in cases.entries) {
        test('${entry.key}ms -> ${entry.value}', () {
          expect(SwingDuration(entry.key).label, entry.value);
        });
      }
    });
  });
}
