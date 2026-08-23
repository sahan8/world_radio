import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_text_styles.dart';
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
    return InkWell(
      onTap: () => player.select(station, queue: queue),
      borderRadius: BorderRadius.circular(AppRadii.medium),
      child: Container(
        width: 184,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.medium),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 132,
              width: double.infinity,
              child: StationThumbnail(station: station),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.textPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('LIVE', style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 6),
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
                IconButton(
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
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 40,
                  ),
                  padding: EdgeInsets.zero,
                ),
                IconButton.filled(
                  onPressed: () => current
                      ? player.togglePlaying()
                      : player.select(station, queue: queue),
                  tooltip: 'Play ${station.name}',
                  icon: current && player.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          current && player.isPlaying
                              ? Icons.pause
                              : player.hasError && current
                              ? Icons.refresh
                              : Icons.play_arrow,
                        ),
                  constraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 44,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
