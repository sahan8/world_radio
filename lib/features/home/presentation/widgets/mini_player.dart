import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../player/application/player_controller.dart';
import '../../../player/presentation/player_screen.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../widgets/visuals/radio_visuals.dart';
import '../../../../widgets/controls/themed_play_button.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = PlayerScope.of(context);
    final station = controller.currentStation;
    return AnimatedSwitcher(
      duration: AppMotion.responsive(context, AppMotion.standard),
      transitionBuilder: (child, animation) => SlideTransition(
        position: Tween(begin: const Offset(0, .22), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        ),
      ),
      child: station == null
          ? const SizedBox.shrink(key: ValueKey('inactive'))
          : Container(
              key: const ValueKey('active'),
              constraints: const BoxConstraints(minHeight: 96),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                border: Border(
                  top: BorderSide(color: Theme.of(context).colorScheme.outline),
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: const Key('mini-player-open'),
                  onTap: () => Navigator.of(context).push(PlayerScreen.route()),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 7, 10, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NOW PLAYING // WORLD RADIO',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontFamily: 'monospace',
                                letterSpacing: .8,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .outlineVariant,
                                ),
                              ),
                              child: Hero(
                                tag: 'station-signal-${station.id}',
                                child: DotMatrixSignal(
                                  size: 58,
                                  active: controller.isPlaying,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: AppMotion.responsive(
                                  context,
                                  AppMotion.quick,
                                ),
                                child: Column(
                                  key: ValueKey(station.id),
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      station.stationName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    Text(
                                      '${station.displayCountry} · ${station.technicalSummary}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ThemedPlayButton(
                              tooltip: controller.isLoading
                                  ? 'Buffering ${station.stationName}'
                                  : controller.hasError
                                  ? 'Retry ${station.stationName}'
                                  : controller.isPlaying
                                  ? 'Pause ${station.stationName}'
                                  : 'Play ${station.stationName}',
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                controller.togglePlaying();
                              },
                              loading: controller.isLoading,
                              error: controller.hasError,
                              playing: controller.isPlaying,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
