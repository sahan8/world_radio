import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../widgets/visuals/radio_visuals.dart';
import '../../../../widgets/controls/themed_play_button.dart';
import '../../../player/application/player_controller.dart';
import '../../../library/application/library_controller.dart';
import '../../../stations/domain/radio_station.dart';
import '../../../stations/presentation/widgets/station_thumbnail.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({required this.station, this.queue, super.key});
  final RadioStation station;
  final List<RadioStation>? queue;

  @override
  Widget build(BuildContext context) {
    final controller = PlayerScope.of(context);
    final library = LibraryScope.of(context);
    final favorite = library.isFavorite(station.id);
    final current = controller.currentStation?.id == station.id;
    return PressableScale(
      child: HoverSlide(
        child: Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              FocusScope.of(context).unfocus();
              controller.select(station, queue: queue);
              Navigator.maybePop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: StationThumbnail(station: station),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                station.stationName,
                                style: AppTextStyles.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (station.isLive)
                              Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: BroadcastIndicator(
                                  active: current && controller.isPlaying,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          [
                            station.displayCountry,
                            if (station.city.isNotEmpty) station.city,
                          ].join(' · '),
                          style: AppTextStyles.body,
                          maxLines: 2,
                        ),
                        Text(
                          '${station.primaryGenre} · ${station.primaryLanguage} · ${station.technicalSummary}',
                          style: AppTextStyles.caption,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        tooltip: favorite ? 'Remove favorite' : 'Add favorite',
                        onPressed: () => library.toggleFavorite(station),
                        icon: Icon(
                          favorite ? Icons.favorite : Icons.favorite_border,
                        ),
                      ),
                      ThemedPlayButton(
                        tooltip: 'Play ${station.stationName}',
                        onPressed: () {
                          current
                              ? controller.togglePlaying()
                              : controller.select(station, queue: queue);
                          Navigator.maybePop(context);
                        },
                        loading: current && controller.isLoading,
                        playing: current && controller.isPlaying,
                        error: current && controller.hasError,
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
