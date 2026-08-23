import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../player/application/player_controller.dart';
import '../../domain/station_preview.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({required this.station, super.key});
  final StationPreview station;

  @override
  Widget build(BuildContext context) {
    final controller = PlayerScope.of(context);
    final favorite = controller.isFavorite(station);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          FocusScope.of(context).unfocus();
          controller.select(station);
          Navigator.maybePop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(station.countryCode, style: AppTextStyles.title),
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
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text('LIVE', style: AppTextStyles.caption),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${station.country} · ${station.city}',
                      style: AppTextStyles.body,
                      maxLines: 2,
                    ),
                    Text(
                      '${station.genre} · ${station.language}${station.frequency == null ? '' : ' · ${station.frequency}'}',
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
                    onPressed: () => controller.toggleFavorite(station),
                    icon: Icon(
                      favorite ? Icons.favorite : Icons.favorite_border,
                    ),
                  ),
                  IconButton.filled(
                    tooltip: 'Play ${station.stationName}',
                    onPressed: () {
                      controller.select(station);
                      Navigator.maybePop(context);
                    },
                    icon: const Icon(Icons.play_arrow),
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
