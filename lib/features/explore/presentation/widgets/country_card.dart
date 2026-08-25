import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/neumorphic.dart';
import '../../../../core/motion/app_motion.dart';
import '../../../../widgets/visuals/dot_matrix_text.dart';
import '../../data/explore_data.dart';

class ExploreCountryCard extends StatelessWidget {
  const ExploreCountryCard({required this.country, this.onTap, super.key});

  final CountryDestination country;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => PressableScale(
    scale: .975,
    child: HoverSlide(
      scale: 1.01,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.medium),
          boxShadow: Neumorphic.raised(context, depth: .55),
        ),
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadii.medium),
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
                    const Text(
                      'OPEN DIRECTORY',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
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
      borderRadius: BorderRadius.circular(AppRadii.small),
    ),
    child: SizedBox(
      width: 44,
      height: 28,
      child: DotMatrixText(code, fontSize: 28),
    ),
  );
}
