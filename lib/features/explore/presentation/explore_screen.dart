import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../search/presentation/widgets/search_entry_bar.dart';
import '../../stations/presentation/station_collection_screen.dart';
import '../data/explore_data.dart';
import 'widgets/country_card.dart';
import 'widgets/discovery_selector.dart';
import 'widgets/explore_header.dart';
import 'widgets/genre_card.dart';
import 'widgets/language_tile.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  DiscoveryCategory _selectedCategory = DiscoveryCategory.countries;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return CustomScrollView(
      key: const PageStorageKey('explore-scroll'),
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(24, 32, 24, 0),
          sliver: SliverToBoxAdapter(child: ExploreHeader()),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
          sliver: SliverToBoxAdapter(
            child: SearchEntryBar(hint: 'Search global radio...'),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          sliver: SliverToBoxAdapter(
            child: DiscoverySelector(
              selected: _selectedCategory,
              onSelected: (category) =>
                  setState(() => _selectedCategory = category),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _sectionTitle,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Text(_sectionCount, style: AppTextStyles.caption),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          sliver: SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: reduceMotion
                  ? Duration.zero
                  : const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: _DiscoveryContent(
                key: ValueKey(_selectedCategory),
                category: _selectedCategory,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  String get _sectionTitle => switch (_selectedCategory) {
    DiscoveryCategory.countries => 'COUNTRIES',
    DiscoveryCategory.genres => 'GENRES',
    DiscoveryCategory.languages => 'LANGUAGES',
  };

  String get _sectionCount => switch (_selectedCategory) {
    DiscoveryCategory.countries =>
      '${ExploreData.countries.length} destinations',
    DiscoveryCategory.genres => '${ExploreData.genres.length} categories',
    DiscoveryCategory.languages => '${ExploreData.languages.length} languages',
  };
}

class _DiscoveryContent extends StatelessWidget {
  const _DiscoveryContent({required this.category, super.key});

  final DiscoveryCategory category;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      const spacing = 12.0;
      final columns = constraints.maxWidth >= 720 ? 3 : 2;
      final itemWidth =
          (constraints.maxWidth - spacing * (columns - 1)) / columns;
      final children = switch (category) {
        DiscoveryCategory.countries => [
          for (final country in ExploreData.countries)
            ExploreCountryCard(
              country: country,
              onTap: () => _open(
                context,
                country.name,
                country.code,
                StationCollectionType.country,
              ),
            ),
        ],
        DiscoveryCategory.genres => [
          for (final genre in ExploreData.genres)
            GenreCard(
              genre: genre,
              onTap: () => _open(
                context,
                genre.name,
                genre.name.toLowerCase(),
                StationCollectionType.genre,
              ),
            ),
        ],
        DiscoveryCategory.languages => [
          for (final language in ExploreData.languages)
            LanguageTile(
              language: language,
              onTap: () => _open(
                context,
                language.name,
                language.name.toLowerCase(),
                StationCollectionType.language,
              ),
            ),
        ],
      };

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final child in children)
            SizedBox(width: itemWidth, child: child),
        ],
      );
    },
  );

  static void _open(
    BuildContext context,
    String title,
    String value,
    StationCollectionType type,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            StationCollectionScreen(title: title, value: value, type: type),
      ),
    );
  }
}
