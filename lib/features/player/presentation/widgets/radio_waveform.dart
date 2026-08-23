import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class RadioWaveform extends StatefulWidget {
  const RadioWaveform({required this.playing, super.key});
  final bool playing;
  @override
  State<RadioWaveform> createState() => _RadioWaveformState();
}

class _RadioWaveformState extends State<RadioWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(RadioWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    if (widget.playing && !MediaQuery.disableAnimationsOf(context)) {
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
  Widget build(BuildContext context) => SizedBox(
    height: 50,
    child: AnimatedBuilder(
      animation: _controller,
      builder: (_, _) => CustomPaint(
        size: const Size(double.infinity, 50),
        painter: _WavePainter(_controller.value),
      ),
    ),
  );
}

class _WavePainter extends CustomPainter {
  _WavePainter(this.phase);
  final double phase;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square;
    for (var i = 0; i < 24; i++) {
      final x = size.width * i / 23;
      final h = 7 + 30 * (.5 + .5 * math.sin(i * 1.17 + phase * math.pi * 2));
      canvas.drawLine(
        Offset(x, size.height / 2 - h / 2),
        Offset(x, size.height / 2 + h / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => oldDelegate.phase != phase;
}
