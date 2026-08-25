import 'package:flutter/material.dart';

import '../../stations/data/radio_browser_service.dart';
import '../../stations/presentation/station_collection_screen.dart';
import '../../library/application/library_controller.dart';
import '../../search/presentation/widgets/search_result_tile.dart';
import '../application/home_radio_controller.dart';
import 'widgets/category_chip.dart';
import 'widgets/country_card.dart';
import 'widgets/featured_radio_device.dart';
import 'widgets/home_header.dart';
import '../../search/presentation/widgets/search_entry_bar.dart';
import 'widgets/section_header.dart';
import '../../../widgets/visuals/radio_visuals.dart';
import '../../../core/motion/app_motion.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeRadioController _radio = HomeRadioController(
    RadioBrowserService(),
  )..addListener(_refresh);

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
  @override
  void initState() {
    super.initState();
    _radio.load();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _radio.removeListener(_refresh);
    _radio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final library = LibraryScope.of(context);
    return RefreshIndicator(
      onRefresh: _radio.load,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: CustomScrollView(
            key: const PageStorageKey('home-scroll'),
            slivers: [
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 22, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: MotionReveal(child: HomeHeader()),
                ),
              ),
              if (_radio.state == StationLoadState.success &&
                  _radio.stations.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: MotionReveal(
                      delay: const Duration(milliseconds: 35),
                      child: FeaturedRadioDevice(
                        station: _radio.stations.first,
                        queue: _radio.stations,
                      ),
                    ),
                  ),
                ),
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: MotionReveal(
                    delay: Duration(milliseconds: 70),
                    child: SearchEntryBar(),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: MotionReveal(
                    delay: const Duration(milliseconds: 105),
                    child: SectionHeader(
                      title: 'LIVE NOW',
                      onAction: () => _openCollection(
                        context,
                        'Popular stations',
                        '',
                        StationCollectionType.popular,
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _LiveStations(controller: _radio)),
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(title: 'EXPLORE THE WORLD'),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 140,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _countries.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final country = _countries[index];
                      return CountryCard(
                        name: country.$1,
                        countryCode: country.$2,
                        stationCount: country.$3,
                        onTap: () => _openCollection(
                          context,
                          country.$1,
                          country.$2,
                          StationCollectionType.country,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: SectionHeader(title: 'BROWSE'),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final category in _categories)
                        CategoryChip(
                          label: category,
                          onTap: () => _openCollection(
                            context,
                            category,
                            category.toLowerCase(),
                            StationCollectionType.genre,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 28, 20, 12),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      const Expanded(
                        child: SectionHeader(title: 'RECENTLY PLAYED'),
                      ),
                      if (library.recentStations.isNotEmpty)
                        IconButton(
                          tooltip: 'Clear listening history',
                          onPressed: () =>
                              _confirmClearHistory(context, library),
                          icon: const Icon(Icons.delete_outline),
                        ),
                    ],
                  ),
                ),
              ),
              if (library.recentStations.isEmpty)
                const SliverPadding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverToBoxAdapter(
                    child: Text('Stations you play will appear here.'),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverList.separated(
                    itemCount: library.recentStations.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final station = library.recentStations[index];
                      return SearchResultTile(
                        station: station,
                        queue: library.recentStations,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmClearHistory(
    BuildContext context,
    LibraryController library,
  ) async {
    final clear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear listening history?'),
        content: const Text(
          'This removes all recently played stations from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('CLEAR'),
          ),
        ],
      ),
    );
    if (clear == true) {
      await library.clearHistory();
    }
  }

  void _openCollection(
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

class _LiveStations extends StatelessWidget {
  const _LiveStations({required this.controller});
  final HomeRadioController controller;
  @override
  Widget build(BuildContext context) => switch (controller.state) {
    StationLoadState.loading => const SizedBox(
      height: 232,
      child: Center(child: SignalLoader()),
    ),
    StationLoadState.error => SizedBox(
      height: 180,
      child: _Message(
        icon: Icons.signal_wifi_connected_no_internet_4,
        title: 'NO SIGNAL',
        message: "We couldn't reach the radio network.",
        action: controller.load,
      ),
    ),
    StationLoadState.empty => const SizedBox(
      height: 180,
      child: _Message(
        icon: Icons.radio_outlined,
        title: 'NO STATIONS FOUND',
        message: 'Pull down to try again.',
      ),
    ),
    StationLoadState.success => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (final station in controller.stations.take(4)) ...[
            SearchResultTile(station: station, queue: controller.stations),
            if (station != controller.stations.take(4).last)
              const SizedBox(height: 8),
          ],
        ],
      ),
    ),
  };
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(title),
          Text(message, textAlign: TextAlign.center),
          if (action != null)
            TextButton(onPressed: action, child: const Text('TRY AGAIN')),
        ],
      ),
    ),
  );
}
