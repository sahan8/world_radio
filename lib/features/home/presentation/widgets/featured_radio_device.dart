import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/motion/app_motion.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/neumorphic.dart';
import '../../../../widgets/visuals/radio_visuals.dart';
import '../../../../widgets/controls/themed_play_button.dart';
import '../../../player/application/player_controller.dart';
import '../../../stations/domain/radio_station.dart';

class FeaturedRadioDevice extends StatelessWidget {
  const FeaturedRadioDevice({
    required this.station,
    required this.queue,
    super.key,
  });

  final RadioStation station;
  final List<RadioStation> queue;

  @override
  Widget build(BuildContext context) {
    final player = PlayerScope.of(context);
    final colors = Theme.of(context).colorScheme;
    final current = player.currentStation?.id == station.id;
    final active = current && player.isPlaying;
    return PressableScale(
      scale: .985,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadii.hero),
          border: Border.all(color: colors.onSurface.withValues(alpha: .04)),
          boxShadow: Neumorphic.raised(context),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.hero),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              HapticFeedback.mediumImpact();
              current
                  ? player.togglePlaying()
                  : player.select(station, queue: queue);
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'WORLD RADIO // SIGNAL 001',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          letterSpacing: .8,
                        ),
                      ),
                      const Spacer(),
                      BroadcastIndicator(active: active),
                    ],
                  ),
                  const SizedBox(height: 2),
                  DotMatrixSignal(active: active, size: 164),
                  Text(
                    station.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    station.displayCountry,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(AppRadii.medium),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${station.displayCountry.toUpperCase()} // ${station.codec.isEmpty ? 'STREAM' : station.codec} // ${station.bitrate > 0 ? '${station.bitrate}K' : 'LIVE'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontFamily: 'monospace'),
                          ),
                        ),
                        SizedBox(
                          width: 52,
                          height: 52,
                          child: ThemedPlayButton(
                            tooltip: active
                                ? 'Pause ${station.name}'
                                : 'Play ${station.name}',
                            onPressed: () => current
                                ? player.togglePlaying()
                                : player.select(station, queue: queue),
                            loading: player.isLoading && current,
                            playing: active,
                          ),
                        ),
                      ],
                    ),
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
