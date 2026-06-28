import 'package:flutter/material.dart';

/// ボールを真上から撮影する際の位置合わせを助ける十字＋円のオーバーレイ。
class OverheadAlignmentGuide extends StatelessWidget {
  const OverheadAlignmentGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _GuidePainter(), child: const SizedBox.expand()),
    );
  }
}

class _GuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.12;

    canvas.drawCircle(center, radius, paint);
    canvas.drawLine(
      center.translate(-radius * 1.6, 0),
      center.translate(-radius * 0.6, 0),
      paint,
    );
    canvas.drawLine(
      center.translate(radius * 0.6, 0),
      center.translate(radius * 1.6, 0),
      paint,
    );
    canvas.drawLine(
      center.translate(0, -radius * 1.6),
      center.translate(0, -radius * 0.6),
      paint,
    );
    canvas.drawLine(
      center.translate(0, radius * 0.6),
      center.translate(0, radius * 1.6),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
