import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/dtos/playback_args.dart';
import '../../../domain/entities/swing_session.dart';
import '../../providers/providers.dart';
import '../../widgets/swing_session_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(allSwingSessionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('履歴')),
      body: sessionsAsync.when(
        data: (sessions) {
          if (sessions.isEmpty) {
            return const Center(child: Text('まだスイングが記録されていません'));
          }
          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return Dismissible(
                key: ValueKey(session.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await ref
                      .read(deleteSwingSessionUseCaseProvider)
                      .execute(session.id);
                  ref.invalidate(allSwingSessionsProvider);
                },
                child: SwingSessionCard(
                  session: session,
                  onTap: () => _openPlayback(context, session),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('読み込みに失敗しました: $error')),
      ),
    );
  }

  void _openPlayback(BuildContext context, SwingSession session) {
    context.push(
      '/playback',
      extra: PlaybackArgs(session: session, isFreshRecording: false),
    );
  }
}
