import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/exceptions/recording_failed_exception.dart';

class VideoStorageService {
  Future<String> persist(XFile tempFile) async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final swingsDir = Directory(p.join(docsDir.path, 'swings'));
      await swingsDir.create(recursive: true);

      final filename = 'swing_${DateTime.now().millisecondsSinceEpoch}.mp4';
      final destPath = p.join(swingsDir.path, filename);
      await File(tempFile.path).copy(destPath);
      return destPath;
    } catch (e) {
      throw RecordingFailedException('録画ファイルの保存に失敗しました: $e');
    }
  }

  Future<void> delete(String videoPath) async {
    final file = File(videoPath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
