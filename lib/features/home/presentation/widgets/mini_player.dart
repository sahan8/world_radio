import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'station_artwork.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 82),
    padding: const EdgeInsets.fromLTRB(12, 9, 10, 9),
    decoration: const BoxDecoration(
      color: AppColors.surfaceElevated,
      border: Border(
        top: BorderSide(color: AppColors.border),
        bottom: BorderSide(color: AppColors.borderSubtle),
      ),
    ),
    child: Row(
      children: [
        const StationArtwork(label: 'BBC', size: 56),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BBC Radio 1',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'United Kingdom · Pop',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          tooltip: 'Add to favorites',
          icon: const Icon(Icons.favorite_border),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        ),
        IconButton.filled(
          onPressed: () {},
          tooltip: 'Play BBC Radio 1',
          icon: const Icon(Icons.play_arrow),
          constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          padding: EdgeInsets.zero,
        ),
      ],
    ),
  );
}
