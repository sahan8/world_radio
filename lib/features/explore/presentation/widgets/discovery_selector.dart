import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../data/explore_data.dart';

class DiscoverySelector extends StatelessWidget {
  const DiscoverySelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final DiscoveryCategory selected;
  final ValueChanged<DiscoveryCategory> onSelected;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final category in DiscoveryCategory.values)
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: category == DiscoveryCategory.languages ? 0 : 8,
            ),
            child: _SelectorItem(
              label: _labelFor(category),
              selected: selected == category,
              onTap: () {
                if (selected == category) return;
                HapticFeedback.selectionClick();
                onSelected(category);
              },
            ),
          ),
        ),
    ],
  );

  String _labelFor(DiscoveryCategory category) => switch (category) {
    DiscoveryCategory.countries => 'Countries',
    DiscoveryCategory.genres => 'Genres',
    DiscoveryCategory.languages => 'Languages',
  };
}

class _SelectorItem extends StatelessWidget {
  const _SelectorItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected ? AppColors.surfaceElevated : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.small),
        border: Border.all(
          color: selected ? AppColors.textPrimary : AppColors.borderSubtle,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.small),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: selected ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
