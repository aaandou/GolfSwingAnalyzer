import 'package:flutter_test/flutter_test.dart';
import 'package:golf_swing_analyzer/presentation/screens/playback/playback_screen.dart';

void main() {
  group('deleteConfirmationMessage', () {
    test('asks about discarding the recording when fresh', () {
      expect(
        deleteConfirmationMessage(isFreshRecording: true),
        'この録画を削除しますか？',
      );
    });

    test('warns that deletion is permanent when viewed from history', () {
      expect(
        deleteConfirmationMessage(isFreshRecording: false),
        'このスイングを削除しますか？元に戻せません。',
      );
    });
  });
}
