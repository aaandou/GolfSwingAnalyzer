import 'package:easy_video_editor/easy_video_editor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/exceptions/recording_failed_exception.dart';

class VideoTrimService {
  Future<String> trim(String videoPath, Duration start, Duration end) async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final swingsDir = p.join(docsDir.path, 'swings');
      final outputPath = p.join(
        swingsDir,
        'swing_${DateTime.now().millisecondsSinceEpoch}.mp4',
      );

      final result = await VideoEditorBuilder(videoPath: videoPath)
          .trim(startTimeMs: start.inMilliseconds, endTimeMs: end.inMilliseconds)
          .export(outputPath: outputPath);

      return result ?? outputPath;
    } catch (e) {
      throw RecordingFailedException('動画のトリミングに失敗しました: $e');
    }
  }
}
