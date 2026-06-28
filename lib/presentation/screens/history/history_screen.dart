import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/dtos/playback_args.dart';
import '../../../domain/entities/swing_session.dart';
import '../../providers/providers.dart';
import '../../widgets/swing_session_card.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final Set<int> _pendingDeleteIds = {};

  Future<void> _delete(int id) async {
    // Dismissibleは onDismissed が呼ばれた時点で、そのウィジェットが次のビルドまでに
    // ツリーから取り除かれていることを要求する。削除APIの完了を待ってからリストを
    // 更新すると、その待ち時間の間は古いリストのままになりアサーションエラーが発生するため、
    // 先にローカルで非表示にしてから非同期の削除処理を行う。
    //
    // ref.invalidate後もRiverpodはデフォルトで再取得完了まで直前のデータを
    // 返す（skipLoadingOnRefresh: true）。そのためidをこのSetから取り除くのは
    // 「本当に削除された」ことが新しいデータで確認できた後でなければならず、
    // invalidateの直後に取り除くと古いデータに削除対象がまだ残っていて復活してしまう。
    // 削除済みのidが再度サーバーから返ることはないため、ここでは取り除かず
    // 保持し続ける（ウィジェットのライフタイム中のみ保持される小さなSetのため問題ない）。
    setState(() => _pendingDeleteIds.add(id));
    await ref.read(deleteSwingSessionUseCaseProvider).execute(id);
    ref.invalidate(allSwingSessionsProvider);
  }

  void _openPlayback(BuildContext context, SwingSession session) {
    context.push(
      '/playback',
      extra: PlaybackArgs(session: session, isFreshRecording: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(allSwingSessionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('履歴')),
      body: sessionsAsync.when(
        data: (sessions) {
          final visibleSessions = sessions
              .where((session) => !_pendingDeleteIds.contains(session.id))
              .toList();
          if (visibleSessions.isEmpty) {
            return const Center(child: Text('まだスイングが記録されていません'));
          }
          return ListView.builder(
            itemCount: visibleSessions.length,
            itemBuilder: (context, index) {
              final session = visibleSessions[index];
              return Dismissible(
                key: ValueKey(session.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => _delete(session.id),
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
}
