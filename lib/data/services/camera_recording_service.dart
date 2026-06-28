import 'package:camera/camera.dart';

import '../../domain/exceptions/camera_initialization_exception.dart';
import '../../domain/exceptions/recording_failed_exception.dart';

/// 撮影に使う目標フレームレート。実機が対応していない場合は
/// プラットフォーム側でデフォルト値にフォールバックされる（best-effort）。
const int kTargetFps = 60;

class CameraRecordingService {
  CameraController? _controller;
  DateTime? _recordingStartedAt;

  CameraController? get controller => _controller;

  Future<void> initialize() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw CameraInitializationException('利用可能なカメラが見つかりません');
      }
      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        back,
        ResolutionPreset.high,
        enableAudio: false,
        fps: kTargetFps,
      );
      await controller.initialize();
      _controller = controller;
    } on CameraException catch (e) {
      throw CameraInitializationException(
        'カメラの初期化に失敗しました: ${e.description ?? e.code}',
      );
    }
  }

  Future<void> startRecording() async {
    final controller = _controller;
    if (controller == null) {
      throw RecordingFailedException('カメラが初期化されていません');
    }
    try {
      await controller.startVideoRecording();
      _recordingStartedAt = DateTime.now();
    } on CameraException catch (e) {
      throw RecordingFailedException(
        '録画の開始に失敗しました: ${e.description ?? e.code}',
      );
    }
  }

  Future<(XFile file, Duration elapsed)> stopRecording() async {
    final controller = _controller;
    final startedAt = _recordingStartedAt;
    if (controller == null || startedAt == null) {
      throw RecordingFailedException('録画が開始されていません');
    }
    try {
      final file = await controller.stopVideoRecording();
      final elapsed = DateTime.now().difference(startedAt);
      _recordingStartedAt = null;
      return (file, elapsed);
    } on CameraException catch (e) {
      throw RecordingFailedException(
        '録画の停止に失敗しました: ${e.description ?? e.code}',
      );
    }
  }

  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}
