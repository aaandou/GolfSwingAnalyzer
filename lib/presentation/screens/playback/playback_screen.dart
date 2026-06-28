import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../../application/dtos/playback_args.dart';
import '../../providers/providers.dart';

const List<double> kPlaybackSpeeds = [1.0, 0.5, 0.25, 0.1];

class PlaybackScreen extends ConsumerStatefulWidget {
  final PlaybackArgs args;

  const PlaybackScreen({super.key, required this.args});

  @override
  ConsumerState<PlaybackScreen> createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends ConsumerState<PlaybackScreen> {
  late final VideoPlayerController _controller;
  late final Future<void> _initializeFuture;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(
      File(widget.args.session.videoPath.value),
    );
    _initializeFuture = _controller.initialize().then((_) {
      _controller.setVolume(0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Duration get _frameDuration => Duration(
    milliseconds: (1000 / widget.args.session.targetFps.value).round(),
  );

  void _stepFrame(int direction) {
    final position = _controller.value.position;
    final target = position + _frameDuration * direction;
    final clamped = target < Duration.zero ? Duration.zero : target;
    _controller.pause();
    _controller.seekTo(clamped);
  }

  Future<void> _save() async {
    setState(() => _isProcessing = true);
    final prepared = await ref
        .read(prepareSwingClipUseCaseProvider)
        .execute(widget.args.session);
    await ref.read(saveSwingSessionUseCaseProvider).execute(prepared);
    if (!mounted) return;
    ref.invalidate(allSwingSessionsProvider);
    GoRouter.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存しました')),
    );
  }

  Future<void> _discard() async {
    await ref
        .read(videoStorageServiceProvider)
        .delete(widget.args.session.videoPath.value);
    if (!mounted) return;
    GoRouter.of(context).pop();
  }

  Future<void> _delete() async {
    await ref
        .read(deleteSwingSessionUseCaseProvider)
        .execute(widget.args.session.id);
    if (!mounted) return;
    ref.invalidate(allSwingSessionsProvider);
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final speed = ref.watch(playbackSpeedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('スイングレビュー')),
      body: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Column(
            children: [
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: _controller,
                builder: (context, value, _) {
                  final duration = value.duration;
                  return Slider(
                    value: value.position.inMilliseconds
                        .clamp(0, duration.inMilliseconds)
                        .toDouble(),
                    max: duration.inMilliseconds.toDouble().clamp(1, double.infinity),
                    onChanged: (v) {
                      _controller.pause();
                      _controller.seekTo(Duration(milliseconds: v.round()));
                    },
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: () => _stepFrame(-1),
                  ),
                  ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: _controller,
                    builder: (context, value, _) => IconButton(
                      icon: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
                      iconSize: 36,
                      onPressed: () {
                        if (value.isPlaying) {
                          _controller.pause();
                        } else {
                          _controller.play();
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: () => _stepFrame(1),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: kPlaybackSpeeds.map((s) {
                    return ChoiceChip(
                      label: Text('${s}x'),
                      selected: speed == s,
                      onSelected: (_) {
                        ref.read(playbackSpeedProvider.notifier).state = s;
                        _controller.setPlaybackSpeed(s);
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: widget.args.isFreshRecording
                    ? Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isProcessing ? null : _discard,
                              child: const Text('削除'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isProcessing ? null : _save,
                              child: _isProcessing
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('保存'),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _delete,
                          child: const Text('削除'),
                        ),
                      ),
              ),
              const SizedBox(height: 16),
            ],
            ),
          );
        },
      ),
    );
  }
}
