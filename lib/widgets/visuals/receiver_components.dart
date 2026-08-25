import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_radii.dart';

class RadioDisplay extends StatelessWidget {
  const RadioDisplay({required this.value, this.label, super.key});
  final String value;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: [value, label].whereType<String>().join(' '),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadii.medium),
          border: Border.all(color: colors.outline),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: .18),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontFamily: 'monospace', letterSpacing: 2),
            ),
            if (label != null) ...[
              const SizedBox(height: 3),
              Text(
                label!.toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class RadioDial extends StatelessWidget {
  const RadioDial({
    required this.value,
    required this.label,
    this.size = 190,
    super.key,
  });
  final String value;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final compact = size < 90;
    return Semantics(
      image: true,
      label: 'Tuning display, $value $label',
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _DialPainter(
                  color: colors.onSurface,
                  border: colors.outline,
                ),
              ),
            ),
            Container(
              width: size * .65,
              height: size * .65,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surfaceContainerHighest,
                border: Border.all(color: colors.outline),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow.withValues(alpha: .25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    style:
                        (compact
                                ? Theme.of(context).textTheme.labelSmall
                                : Theme.of(context).textTheme.headlineMedium)
                            ?.copyWith(
                              fontFamily: 'monospace',
                              fontSize: compact ? 10 : null,
                              height: 1,
                            ),
                  ),
                  Text(
                    label.toUpperCase(),
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(fontSize: compact ? 7 : null, height: 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  const _DialPainter({required this.color, required this.border});
  final Color color;
  final Color border;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 8;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = border,
    );
    for (var i = 0; i < 32; i++) {
      final angle = -math.pi * .78 + i * math.pi * 1.56 / 31;
      final major = i % 4 == 0;
      final outer = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      final inner =
          center +
          Offset(math.cos(angle), math.sin(angle)) *
              (radius - (major ? 12 : 6));
      canvas.drawLine(
        inner,
        outer,
        Paint()
          ..strokeWidth = major ? 1.5 : .7
          ..color = color.withValues(alpha: major ? .9 : .45),
      );
    }
    canvas.drawLine(
      Offset(center.dx, 4),
      Offset(center.dx, 26),
      Paint()
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_DialPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.border != border;
}
