import 'package:flutter/material.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/neumorphic.dart';
import '../../data/explore_data.dart';

class GenreCard extends StatelessWidget {
  const GenreCard({required this.genre, this.onTap, super.key});

  final GenreDestination genre;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadii.medium),
      boxShadow: Neumorphic.raised(context, depth: .5),
    ),
    child: Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadii.medium),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 112),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  genre.icon,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 26,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    genre.name.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Icon(Icons.arrow_outward, size: 18),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
