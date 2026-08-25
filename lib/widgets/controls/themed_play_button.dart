import 'package:flutter/material.dart';

import '../../core/motion/app_motion.dart';
import '../visuals/radio_visuals.dart';

class ThemedPlayButton extends StatefulWidget {
  const ThemedPlayButton({
    required this.tooltip,
    required this.onPressed,
    this.playing = false,
    this.loading = false,
    this.error = false,
    this.size = 48,
    this.iconSize = 24,
    super.key,
  });

  final String tooltip;
  final VoidCallback? onPressed;
  final bool playing;
  final bool loading;
  final bool error;
  final double size;
  final double iconSize;

  @override
  State<ThemedPlayButton> createState() => _ThemedPlayButtonState();
}

class _ThemedPlayButtonState extends State<ThemedPlayButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final enabled = widget.onPressed != null;
    final reduced = AppMotion.reduce(context);
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
          onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
          onTapUp: enabled
              ? (_) {
                  setState(() => _pressed = false);
                  widget.onPressed?.call();
                }
              : null,
          child: AnimatedScale(
            scale: reduced
                ? 1
                : _pressed
                ? .94
                : _hovered
                ? 1.04
                : 1,
            duration: AppMotion.fast,
            child: Semantics(
              button: true,
              enabled: enabled,
              label: widget.tooltip,
              child: AnimatedOpacity(
                opacity: enabled ? 1 : .45,
                duration: AppMotion.fast,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: widget.loading
                      ? SignalLoader(compact: true, color: colors.onPrimary)
                      : Icon(
                          widget.error
                              ? Icons.refresh
                              : widget.playing
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: colors.onPrimary,
                          size: widget.iconSize,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
