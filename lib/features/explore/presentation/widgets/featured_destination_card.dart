import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'world_discovery_visual.dart';

class FeaturedDestinationCard extends StatelessWidget {
  const FeaturedDestinationCard({
    required this.city,
    required this.country,
    required this.stationCount,
    super.key,
  });

  final String city;
  final String country;
  final int stationCount;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Listen live in $city, $country',
    child: Material(
      color: AppColors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.medium),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 210),
          child: Stack(
            children: [
              const Positioned(
                width: 190,
                height: 190,
                right: -28,
                top: 10,
                child: Opacity(opacity: .55, child: WorldDiscoveryVisual()),
              ),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FEATURED DESTINATION',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 24),
                    Text(city, style: Theme.of(context).textTheme.displayLarge),
                    const SizedBox(height: 6),
                    Text(
                      '$country  ·  $stationCount stations',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'LISTEN LIVE',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
