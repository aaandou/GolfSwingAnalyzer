import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/dtos/playback_args.dart';
import '../../../data/services/camera_recording_service.dart';
import '../../../domain/entities/swing_session.dart';
import '../../../domain/exceptions/domain_exception.dart';
import '../../../domain/value_objects/fps.dart';
import '../../../domain/value_objects/swing_duration.dart';
import '../../../domain/value_objects/video_path.dart';
import '../../providers/providers.dart';
import '../../widgets/overhead_alignment_guide.dart';

class RecordScreen extends ConsumerStatefulWidget {
  const RecordScreen({super.key});

  @override
  ConsumerState<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends ConsumerState<RecordScreen> {
  late final CameraRecordingService _service;
  Future<void>? _initializeFuture;
  bool _isRecording = false;
  Duration _elapsed = Duration.zero;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _service = ref.read(cameraRecordingServiceProvider);
    _initializeFuture = _service.initialize();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _service.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      await _service.startRecording();
      setState(() {
        _isRecording = true;
        _elapsed = Duration.zero;
      });
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _elapsed += const Duration(seconds: 1));
      });
    } on DomainException catch (e) {
      _showError(e.message);
    }
  }

  Future<void> _stopRecording() async {
    _ticker?.cancel();
    try {
      final (file, elapsed) = await _service.stopRecording();
      setState(() => _isRecording = false);
      final videoPath = await ref
          .read(videoStorageServiceProvider)
          .persist(file);
      final draft = SwingSession(
        id: 0,
        videoPath: VideoPath(videoPath),
        recordedAt: DateTime.now(),
        duration: SwingDuration(elapsed.inMilliseconds),
        targetFps: Fps(kTargetFps),
      );
      if (!mounted) return;
      context.push(
        '/playback',
        extra: PlaybackArgs(session: draft, isFreshRecording: true),
      );
    } on DomainException catch (e) {
      setState(() => _isRecording = false);
      _showError(e.message);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatElapsed(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('スイング撮影')),
      body: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final message = snapshot.error is DomainException
                ? (snapshot.error as DomainException).message
                : 'カメラの初期化に失敗しました';
            return Center(child: Text(message));
          }
          final controller = _service.controller;
          if (controller == null) {
            return const Center(child: Text('カメラを利用できません'));
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller, child: const OverheadAlignmentGuide()),
              if (_isRecording)
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatElapsed(_elapsed),
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Center(
                  child: FloatingActionButton.large(
                    backgroundColor: _isRecording ? Colors.red : Colors.white,
                    onPressed: _isRecording ? _stopRecording : _startRecording,
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.fiber_manual_record,
                      color: _isRecording ? Colors.white : Colors.red,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
