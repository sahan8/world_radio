import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/neumorphic.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({
    required this.name,
    required this.countryCode,
    required this.stationCount,
    this.onTap,
    super.key,
  });
  final String name;
  final String countryCode;
  final String stationCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.medium),
      child: Container(
        width: 148,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadii.medium),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface
                .withValues(alpha: .04),
          ),
          boxShadow: Neumorphic.raised(context, depth: .7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadii.small),
                boxShadow: Neumorphic.pressed(context),
              ),
              child: Text(
                countryCode,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const Spacer(),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 2),
            Text(
              stationCount,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ),
  );
}
