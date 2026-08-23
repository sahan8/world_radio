import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../data/explore_data.dart';

class ExploreCountryCard extends StatelessWidget {
  const ExploreCountryCard({required this.country, this.onTap, super.key});

  final CountryDestination country;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.medium),
      side: const BorderSide(color: AppColors.borderSubtle),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 152,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _CountryMarker(code: country.code),
                  const Spacer(),
                  const Icon(Icons.arrow_outward, size: 18),
                ],
              ),
              const Spacer(),
              Text(
                country.name.toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '${country.stationCount} stations',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _CountryMarker extends StatelessWidget {
  const _CountryMarker({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minWidth: 42, minHeight: 32),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(AppRadii.small),
    ),
    child: Text(
      code,
      style: Theme.of(context).textTheme.labelLarge
          ?.copyWith(color: AppColors.textPrimary),
    ),
  );
}
