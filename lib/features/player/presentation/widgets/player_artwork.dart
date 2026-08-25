import 'package:flutter/material.dart';

import '../../../stations/domain/radio_station.dart';

class PlayerArtwork extends StatelessWidget {
  const PlayerArtwork({
    required this.station,
    this.hero = true,
    this.size,
    super.key,
  });
  final RadioStation station;
  final bool hero;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final artwork = AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: size,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _GridPainter(
                  border: Theme.of(context).colorScheme.outline,
                  subtle: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            Positioned(
              top: 18,
              left: 18,
              child: Text(
                station.technicalSummary,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: FittedBox(
                  child: Text(
                    _initials(station.stationName),
                    style: Theme.of(context).textTheme.displayLarge
                        ?.copyWith(fontSize: 58, letterSpacing: 4),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 16,
              child: Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        station.countryCode,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text('● LIVE'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return hero
        ? Hero(tag: 'station-art-${station.id}', child: artwork)
        : artwork;
  }

  static String _initials(String name) => name
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .take(3)
      .map((word) => word[0])
      .join()
      .toUpperCase();
}

class _GridPainter extends CustomPainter {
  const _GridPainter({required this.border, required this.subtle});
  final Color border;
  final Color subtle;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = subtle.withValues(alpha: .55)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += size.width / 8) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += size.height / 8) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * .28,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = border,
    );
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) =>
      oldDelegate.border != border || oldDelegate.subtle != subtle;
}
