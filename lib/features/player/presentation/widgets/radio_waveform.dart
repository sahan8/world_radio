import 'dart:math' as math;

import 'package:flutter/material.dart';

class RadioWaveform extends StatefulWidget {
  const RadioWaveform({
    required this.playing,
    this.buffering = false,
    this.error = false,
    super.key,
  });
  final bool playing;
  final bool buffering;
  final bool error;
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
    if ((widget.playing || widget.buffering) &&
        !widget.error &&
        !MediaQuery.disableAnimationsOf(context)) {
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
        painter: _WavePainter(
          _controller.value,
          playing: widget.playing,
          buffering: widget.buffering,
          error: widget.error,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    ),
  );
}

class _WavePainter extends CustomPainter {
  _WavePainter(
    this.phase, {
    required this.playing,
    required this.buffering,
    required this.error,
    required this.color,
  });
  final double phase;
  final bool playing;
  final bool buffering;
  final bool error;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square;
    for (var i = 0; i < 24; i++) {
      final x = size.width * i / 23;
      final activity = error
          ? 0.0
          : buffering
          ? .28
          : playing
          ? 1.0
          : .18;
      final h =
          4 +
          30 * activity * (.5 + .5 * math.sin(i * 1.17 + phase * math.pi * 2));
      canvas.drawLine(
        Offset(x, size.height / 2 - h / 2),
        Offset(x, size.height / 2 + h / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) =>
      oldDelegate.phase != phase ||
      oldDelegate.playing != playing ||
      oldDelegate.buffering != buffering ||
      oldDelegate.error != error ||
      oldDelegate.color != color;
}
