import 'package:flutter/material.dart';

import 'widgets/category_chip.dart';
import 'widgets/country_card.dart';
import 'widgets/home_header.dart';
import '../../search/presentation/widgets/search_entry_bar.dart';
import 'widgets/recent_station_tile.dart';
import 'widgets/section_header.dart';
import 'widgets/station_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _liveStations = [
    ('BBC Radio 1', 'United Kingdom', 'BBC'),
    ('YES FM', 'Sri Lanka', 'YES'),
    ('Tokyo FM', 'Japan', 'TFM'),
    ('KEXP', 'United States', 'KEXP'),
    ('Seoul Community Radio', 'South Korea', 'SCR'),
  ];
  static const _countries = [
    ('Sri Lanka', 'LK', '42 stations'),
    ('Japan', 'JP', '128 stations'),
    ('South Korea', 'KR', '76 stations'),
    ('United Kingdom', 'GB', '215 stations'),
    ('United States', 'US', '640 stations'),
    ('France', 'FR', '184 stations'),
  ];
  static const _categories = [
    'Pop',
    'Rock',
    'Jazz',
    'News',
    'Chill',
    'Electronic',
  ];
  static const _recentStations = [
    ('Radio Paradise', 'United States', 'Eclectic', 'RP'),
    ('FIP', 'France', '105.1 FM', 'FIP'),
    ('Kiss FM', 'Sri Lanka', '96.9 FM', 'KISS'),
  ];

  @override
  Widget build(BuildContext context) => CustomScrollView(
    key: const PageStorageKey('home-scroll'),
    slivers: [
      const SliverPadding(
        padding: EdgeInsets.fromLTRB(24, 32, 24, 0),
        sliver: SliverToBoxAdapter(child: HomeHeader()),
      ),
      const SliverPadding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
        sliver: SliverToBoxAdapter(child: SearchEntryBar()),
      ),
      const SliverPadding(
        padding: EdgeInsets.fromLTRB(24, 36, 24, 16),
        sliver: SliverToBoxAdapter(
          child: SectionHeader(title: 'LIVE NOW', showAction: true),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 276,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: _liveStations.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final station = _liveStations[index];
              return StationCard(
                name: station.$1,
                country: station.$2,
                artworkLabel: station.$3,
              );
            },
          ),
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.fromLTRB(24, 36, 24, 16),
        sliver: SliverToBoxAdapter(
          child: SectionHeader(title: 'EXPLORE THE WORLD'),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 140,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: _countries.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final country = _countries[index];
              return CountryCard(
                name: country.$1,
                countryCode: country.$2,
                stationCount: country.$3,
              );
            },
          ),
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.fromLTRB(24, 36, 24, 16),
        sliver: SliverToBoxAdapter(child: SectionHeader(title: 'BROWSE')),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverToBoxAdapter(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final category in _categories) CategoryChip(label: category),
            ],
          ),
        ),
      ),
      const SliverPadding(
        padding: EdgeInsets.fromLTRB(24, 36, 24, 16),
        sliver: SliverToBoxAdapter(
          child: SectionHeader(title: 'RECENTLY PLAYED'),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        sliver: SliverList.separated(
          itemCount: _recentStations.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final station = _recentStations[index];
            return RecentStationTile(
              name: station.$1,
              country: station.$2,
              metadata: station.$3,
              artworkLabel: station.$4,
            );
          },
        ),
      ),
    ],
  );
}
