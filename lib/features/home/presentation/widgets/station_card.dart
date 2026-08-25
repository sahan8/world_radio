import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../widgets/visuals/radio_visuals.dart';
import '../../../../widgets/controls/themed_play_button.dart';
import '../../../player/application/player_controller.dart';
import '../../../library/application/library_controller.dart';
import '../../../stations/domain/radio_station.dart';
import '../../../stations/presentation/widgets/station_thumbnail.dart';

class StationCard extends StatelessWidget {
  const StationCard({required this.station, this.queue, super.key});
  final RadioStation station;
  final List<RadioStation>? queue;

  @override
  Widget build(BuildContext context) {
    final player = PlayerScope.of(context);
    final library = LibraryScope.of(context);
    final current = player.currentStation?.id == station.id;
    return PressableScale(
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          player.select(station, queue: queue);
        },
        borderRadius: BorderRadius.circular(AppRadii.medium),
        child: AnimatedContainer(
          duration: AppMotion.responsive(context, AppMotion.quick),
          width: 174,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadii.medium),
            border: Border.all(
              color: current
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.outline,
              width: current ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 92,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppRadii.small),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: StationThumbnail(station: station),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              BroadcastIndicator(active: current && player.isPlaying),
              const SizedBox(height: 4),
              Text(
                station.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      station.displayCountry,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  SizedBox(
                    width: 34,
                    height: 34,
                    child: IconButton(
                      tooltip: library.isFavorite(station.id)
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        library.toggleFavorite(station);
                      },
                      icon: Icon(
                        library.isFavorite(station.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(
                    width: 38,
                    height: 38,
                    child: ThemedPlayButton(
                      onPressed: () => current
                          ? player.togglePlaying()
                          : player.select(station, queue: queue),
                      tooltip: 'Play ${station.name}',
                      loading: current && player.isLoading,
                      playing: current && player.isPlaying,
                      error: player.hasError && current,
                      size: 38,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
