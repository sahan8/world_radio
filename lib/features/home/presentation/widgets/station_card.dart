import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'station_artwork.dart';

class StationCard extends StatelessWidget {
  const StationCard({
    required this.name,
    required this.country,
    required this.artworkLabel,
    super.key,
  });
  final String name;
  final String country;
  final String artworkLabel;

  @override
  Widget build(BuildContext context) => Container(
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
          child: StationArtwork(label: artworkLabel),
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
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: Text(
                country,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            IconButton.filled(
              onPressed: () {},
              tooltip: 'Play $name',
              icon: const Icon(Icons.play_arrow),
              constraints: const BoxConstraints.tightFor(width: 44, height: 44),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ],
    ),
  );
}
