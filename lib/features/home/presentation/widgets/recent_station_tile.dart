import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import 'station_artwork.dart';

class RecentStationTile extends StatelessWidget {
  const RecentStationTile({
    required this.name,
    required this.country,
    required this.metadata,
    required this.artworkLabel,
    super.key,
  });
  final String name;
  final String country;
  final String metadata;
  final String artworkLabel;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.medium),
      border: Border.all(color: AppColors.borderSubtle),
    ),
    child: Row(
      children: [
        StationArtwork(label: artworkLabel, size: 64),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 3),
              Text(
                country,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                metadata,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {},
          tooltip: 'Play $name',
          icon: const Icon(Icons.play_arrow),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        ),
      ],
    ),
  );
}
