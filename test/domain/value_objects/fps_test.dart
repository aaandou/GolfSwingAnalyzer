import 'package:flutter_test/flutter_test.dart';
import 'package:golf_swing_analyzer/domain/exceptions/invalid_value_object_exception.dart';
import 'package:golf_swing_analyzer/domain/value_objects/fps.dart';

void main() {
  group('Fps', () {
    test('accepts a positive value', () {
      expect(Fps(60).value, 60);
    });

    test('rejects zero', () {
      expect(() => Fps(0), throwsA(isA<InvalidValueObjectException>()));
    });

    test('rejects a negative value', () {
      expect(() => Fps(-30), throwsA(isA<InvalidValueObjectException>()));
    });

    test('equal values are equal', () {
      expect(Fps(60), Fps(60));
      expect(Fps(60), isNot(Fps(30)));
    });
  });
}
