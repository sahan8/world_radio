import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../search/presentation/widgets/search_result_tile.dart';
import '../application/library_controller.dart';
import '../../../core/motion/app_motion.dart';
import '../../../widgets/visuals/radio_visuals.dart';
import '../../../widgets/visuals/dot_matrix_text.dart';

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
            child: Text('MODULE 04', style: AppTextStyles.caption),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 36,
              child: DotMatrixText('SAVED', fontSize: 34),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        if (!library.loaded)
          const SliverFillRemaining(child: Center(child: SignalLoader()))
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
                duration: AppMotion.responsive(context, AppMotion.quick),
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
          const DotHeart(size: 112),
          const SizedBox(height: 16),
          Text(
            'NO SAVED\nSTATIONS',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text('EXPLORE →', style: AppTextStyles.caption),
        ],
      ),
    ),
  );
}
