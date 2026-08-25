import 'dart:async';

import 'package:flutter/widgets.dart';

abstract final class AppMotion {
  static const instant = Duration(milliseconds: 100);
  static const fast = Duration(milliseconds: 150);
  static const quick = Duration(milliseconds: 160);
  static const standard = Duration(milliseconds: 240);
  static const emphasis = Duration(milliseconds: 320);
  static const slow = Duration(milliseconds: 500);
  static const ambient = Duration(milliseconds: 1400);
  static const decorative = Duration(seconds: 12);

  static const standardCurve = Curves.easeOutCubic;
  static const emphasizedCurve = Curves.easeInOutCubicEmphasized;

  static bool reduce(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static Duration responsive(BuildContext context, Duration duration) =>
      reduce(context) ? Duration.zero : duration;
}

class MotionReveal extends StatefulWidget {
  const MotionReveal({
    required this.child,
    this.delay = Duration.zero,
    super.key,
  });
  final Widget child;
  final Duration delay;

  @override
  State<MotionReveal> createState() => _MotionRevealState();
}

class _MotionRevealState extends State<MotionReveal> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.delay != Duration.zero) {
        _timer = Timer(widget.delay, _show);
      } else {
        _show();
      }
    });
  }

  void _show() {
    if (mounted) setState(() => _visible = true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = AppMotion.reduce(context);
    return AnimatedOpacity(
      alwaysIncludeSemantics: true,
      opacity: reduced || _visible ? 1 : 0,
      duration: AppMotion.responsive(context, AppMotion.standard),
      curve: AppMotion.standardCurve,
      child: AnimatedSlide(
        offset: reduced || _visible ? Offset.zero : const Offset(0, .035),
        duration: AppMotion.responsive(context, AppMotion.standard),
        curve: AppMotion.standardCurve,
        child: widget.child,
      ),
    );
  }
}

class HoverSlide extends StatefulWidget {
  const HoverSlide({
    required this.child,
    this.offset = 2,
    this.scale = 1.005,
    super.key,
  });
  final Widget child;
  final double offset;
  final double scale;

  @override
  State<HoverSlide> createState() => _HoverSlideState();
}

class _HoverSlideState extends State<HoverSlide> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = _hovered && !AppMotion.reduce(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: active ? widget.scale : 1,
        duration: AppMotion.responsive(context, AppMotion.fast),
        child: AnimatedSlide(
          offset: active ? Offset(widget.offset / 300, 0) : Offset.zero,
          duration: AppMotion.responsive(context, AppMotion.fast),
          curve: AppMotion.standardCurve,
          child: widget.child,
        ),
      ),
    );
  }
}

class PressableScale extends StatefulWidget {
  const PressableScale({required this.child, this.scale = .98, super.key});
  final Widget child;
  final double scale;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) => Listener(
    onPointerDown: (_) => setState(() => _pressed = true),
    onPointerUp: (_) => setState(() => _pressed = false),
    onPointerCancel: (_) => setState(() => _pressed = false),
    child: AnimatedScale(
      scale: _pressed && !AppMotion.reduce(context) ? widget.scale : 1,
      duration: AppMotion.responsive(context, AppMotion.instant),
      curve: AppMotion.standardCurve,
      child: widget.child,
    ),
  );
}
