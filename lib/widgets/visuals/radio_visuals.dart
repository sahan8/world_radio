import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_text_styles.dart';

class RadioFrequencyGrid extends StatefulWidget {
  const RadioFrequencyGrid({this.opacity = .18, super.key});
  final double opacity;

  @override
  State<RadioFrequencyGrid> createState() => _RadioFrequencyGridState();
}

class _RadioFrequencyGridState extends State<RadioFrequencyGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.decorative,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduce(context)) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) => CustomPaint(
          painter: _FrequencyGridPainter(
            shift: _controller.value,
            opacity: widget.opacity,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    ),
  );
}

class SignalRings extends StatefulWidget {
  const SignalRings({this.active = true, this.size = 260, super.key});
  final bool active;
  final double size;

  @override
  State<SignalRings> createState() => _SignalRingsState();
}

class _SignalRingsState extends State<SignalRings>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(SignalRings oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    if (widget.active && !AppMotion.reduce(context)) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: SizedBox.square(
      dimension: widget.size,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, _) => CustomPaint(
            painter: _SignalRingsPainter(
              _controller.value,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    ),
  );
}

class DotMatrixSignal extends StatefulWidget {
  const DotMatrixSignal({this.size = 180, this.active = true, super.key});

  final double size;
  final bool active;

  @override
  State<DotMatrixSignal> createState() => _DotMatrixSignalState();
}

class DotHeart extends StatelessWidget {
  const DotHeart({this.size = 112, super.key});
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: 'Heart',
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _DotHeartPainter(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    ),
  );
}

class _DotHeartPainter extends CustomPainter {
  const _DotHeartPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const pattern = [
      '001110011100',
      '011111111110',
      '111111111111',
      '111111111111',
      '011111111110',
      '001111111100',
      '000111111000',
      '000011110000',
      '000001100000',
    ];
    final step = size.width / 12;
    final radius = step * .28;
    final offsetY = (size.height - pattern.length * step) / 2;
    for (var y = 0; y < pattern.length; y++) {
      for (var x = 0; x < pattern[y].length; x++) {
        if (pattern[y][x] == '1') {
          canvas.drawCircle(
            Offset((x + .5) * step, offsetY + (y + .5) * step),
            radius,
            Paint()..color = color,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_DotHeartPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _DotMatrixSignalState extends State<DotMatrixSignal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(DotMatrixSignal oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    if (widget.active && !AppMotion.reduce(context)) {
      _controller.repeat();
    } else {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: widget.active ? 'Active radio signal' : 'Paused radio signal',
    child: SizedBox.square(
      dimension: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) => CustomPaint(
          painter: _DotMatrixSignalPainter(
            phase: _controller.value,
            active: widget.active,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    ),
  );
}

class _DotMatrixSignalPainter extends CustomPainter {
  const _DotMatrixSignalPainter({
    required this.phase,
    required this.active,
    required this.color,
  });

  final double phase;
  final bool active;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const cells = 25;
    final step = size.shortestSide / cells;
    final center = const Offset(12, 12);
    for (var y = 0; y < cells; y++) {
      for (var x = 0; x < cells; x++) {
        final dx = (x - center.dx).abs();
        final dy = (y - center.dy).abs();
        final distance = math.sqrt(dx * dx + dy * dy);
        final centerDot = distance < 1.15;
        final vertical = dx < .8 && dy < 6;
        final waveBand = ((distance - 3.2) % 4).abs() < .72;
        final sideWave = waveBand && dx > 2 && dx < 11 && dy < 8;
        final activeCell = centerDot || vertical || sideWave;
        final pulse = active
            ? .58 + .42 * math.sin((distance / 3 - phase * 2) * math.pi).abs()
            : .72;
        final alpha = activeCell ? pulse : .055;
        canvas.drawCircle(
          Offset((x + .5) * step, (y + .5) * step),
          step * (activeCell ? .27 : .16),
          Paint()..color = color.withValues(alpha: alpha),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DotMatrixSignalPainter oldDelegate) =>
      oldDelegate.phase != phase ||
      oldDelegate.active != active ||
      oldDelegate.color != color;
}

class BroadcastIndicator extends StatelessWidget {
  const BroadcastIndicator({this.active = true, super.key});
  final bool active;

  @override
  Widget build(BuildContext context) => Semantics(
    label: active ? 'Live broadcast' : 'Live station',
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: AppMotion.responsive(context, AppMotion.quick),
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: active
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurfaceVariant,
            shape: BoxShape.circle,
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.onSurface
                          .withValues(alpha: .25),
                      blurRadius: 7,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(width: 7),
        ExcludeSemantics(
          child: Text(
            'LIVE',
            style: AppTextStyles.caption.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    ),
  );
}

class SignalLoader extends StatefulWidget {
  const SignalLoader({this.compact = false, this.color, super.key});
  final bool compact;
  final Color? color;

  @override
  State<SignalLoader> createState() => _SignalLoaderState();
}

class _SignalLoaderState extends State<SignalLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AppMotion.reduce(context)) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Loading station',
    child: SizedBox(
      width: widget.compact ? 24 : 132,
      height: widget.compact ? 24 : 42,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) => CustomPaint(
          painter: _SignalLoaderPainter(
            _controller.value,
            color: widget.color ?? Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    ),
  );
}

class _FrequencyGridPainter extends CustomPainter {
  const _FrequencyGridPainter({
    required this.shift,
    required this.opacity,
    required this.color,
  });
  final double shift;
  final double opacity;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final minor = Paint()
      ..color = color.withValues(alpha: opacity * .25)
      ..strokeWidth = .6;
    final major = Paint()
      ..color = color.withValues(alpha: opacity * .55)
      ..strokeWidth = 1;
    final dx = (shift - .5) * 8;
    for (double x = -40 + dx; x < size.width + 40; x += 24) {
      final index = ((x - dx) / 24).round();
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, index.isEven ? size.height : size.height * .96),
        index % 4 == 0 ? major : minor,
      );
    }
    for (double y = 32; y < size.height; y += 64) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minor);
    }
    canvas.drawLine(
      Offset(size.width * .64 + dx, 0),
      Offset(size.width * .64 + dx, size.height),
      Paint()
        ..color = color.withValues(alpha: opacity * .55)
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(_FrequencyGridPainter oldDelegate) =>
      oldDelegate.shift != shift ||
      oldDelegate.opacity != opacity ||
      oldDelegate.color != color;
}

class _SignalRingsPainter extends CustomPainter {
  const _SignalRingsPainter(this.phase, {required this.color});
  final double phase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide * .46;
    for (var i = 0; i < 4; i++) {
      final progress = (phase + i / 4) % 1;
      canvas.drawCircle(
        center,
        maxRadius * (.25 + progress * .75),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = color.withValues(alpha: .16 * (1 - progress)),
      );
    }
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4 + phase * math.pi * .25;
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * maxRadius * .72,
        i.isEven ? 2.2 : 1.4,
        Paint()..color = color.withValues(alpha: .32),
      );
    }
    canvas.drawCircle(center, 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_SignalRingsPainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.color != color;
}

class _SignalLoaderPainter extends CustomPainter {
  const _SignalLoaderPainter(this.phase, {required this.color});
  final double phase;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;
    const bars = 7;
    for (var i = 0; i < bars; i++) {
      final distance = ((i / (bars - 1)) - phase).abs();
      final wrapped = math.min(distance, 1 - distance);
      final energy = (1 - wrapped * 3).clamp(.18, 1.0);
      paint.color = color.withValues(alpha: energy);
      final x = size.width * (i + .5) / bars;
      final height = size.height * (.18 + energy * .7);
      canvas.drawLine(
        Offset(x, (size.height - height) / 2),
        Offset(x, (size.height + height) / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SignalLoaderPainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.color != color;
}
