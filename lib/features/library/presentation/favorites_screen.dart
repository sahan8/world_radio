import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../search/presentation/widgets/search_result_tile.dart';
import '../application/library_controller.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final library = LibraryScope.of(context);
    return CustomScrollView(
      key: const PageStorageKey('favorites-scroll'),
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(24, 32, 24, 8),
          sliver: SliverToBoxAdapter(
            child: Text('YOUR SIGNALS', style: AppTextStyles.caption),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          sliver: SliverToBoxAdapter(
            child: Text(
              'FAVORITES',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Your saved frequencies.',
              style: AppTextStyles.bodyLarge,
            ),
          ),
        ),
        if (!library.loaded)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (library.favorites.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyFavorites(),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            sliver: SliverList.separated(
              itemCount: library.favorites.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, index) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: SearchResultTile(
                  key: ValueKey(library.favorites[index].id),
                  station: library.favorites[index],
                  queue: library.favorites,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.radio_outlined, size: 52),
          const SizedBox(height: 16),
          Text(
            'NO SAVED SIGNALS',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Save stations you want to tune into again.',
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
