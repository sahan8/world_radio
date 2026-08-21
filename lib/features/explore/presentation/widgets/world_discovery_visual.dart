import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class WorldDiscoveryVisual extends StatelessWidget {
  const WorldDiscoveryVisual({super.key});

  @override
  Widget build(BuildContext context) => const AspectRatio(
    aspectRatio: 1,
    child: CustomPaint(
      painter: _WorldDiscoveryPainter(),
      child: Center(
        child: Icon(
          Icons.public,
          size: 30,
          color: AppColors.textSecondary,
          semanticLabel: 'Global radio discovery',
        ),
      ),
    ),
  );
}

class _WorldDiscoveryPainter extends CustomPainter {
  const _WorldDiscoveryPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 - 2;
    final linePaint = Paint()
      ..color = AppColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final subtlePaint = Paint()
      ..color = AppColors.borderSubtle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius, linePaint);
    canvas.drawCircle(center, radius * .72, subtlePaint);
    canvas.drawCircle(center, radius * .42, subtlePaint);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: radius * .9, height: radius * 2),
      subtlePaint,
    );
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      subtlePaint,
    );

    final markerPaint = Paint()..color = AppColors.textPrimary;
    for (final marker in const [
      Offset(.28, .31),
      Offset(.68, .25),
      Offset(.76, .61),
      Offset(.36, .72),
    ]) {
      canvas.drawCircle(
        Offset(size.width * marker.dx, size.height * marker.dy),
        2.5,
        markerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_WorldDiscoveryPainter oldDelegate) => false;
}
