import 'package:flutter/material.dart';

import '../../domain/entities/swing_session.dart';

class SwingSessionCard extends StatelessWidget {
  final SwingSession session;
  final VoidCallback onTap;

  const SwingSessionCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  String _formatDate(DateTime dt) {
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.golf_course)),
        title: Text(_formatDate(session.recordedAt)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '再生時間: ${session.durationLabel} ／ 目標fps: ${session.targetFps.value}',
            ),
            if (!session.impactDetected)
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
                    SizedBox(width: 4),
                    Text(
                      'ミートの瞬間を検出できませんでした',
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
