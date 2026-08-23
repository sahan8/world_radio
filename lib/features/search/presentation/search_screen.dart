import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/placeholder_stations.dart';
import '../domain/station_preview.dart';
import 'widgets/search_empty_state.dart';
import 'widgets/search_result_tile.dart';
import 'widgets/station_filter_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static Route<void> route() => MaterialPageRoute(
    builder: (_) => const SearchScreen(),
    fullscreenDialog: true,
  );

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = SearchController();
  final _focusNode = FocusNode();
  StationFilters _filters = const StationFilters();
  final _recent = ['Japan', 'Jazz', 'BBC Radio', 'Sri Lanka'];
  static const _trending = ['Tokyo', 'Electronic', 'News', 'Chill Radio'];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_refresh);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  List<StationPreview> get _results => placeholderStations
      .where((station) {
        if (!station.matches(_controller.text)) return false;
        if (_filters.country != null && station.country != _filters.country) {
          return false;
        }
        if (_filters.language != null &&
            station.language != _filters.language) {
          return false;
        }
        if (_filters.genre != null &&
            !station.genre.toLowerCase().contains(
              _filters.genre!.toLowerCase(),
            )) {
          return false;
        }
        if (_filters.liveOnly && !station.isLive) {
          return false;
        }
        return true;
      })
      .toList(growable: false);

  Future<void> _openFilters() async {
    FocusScope.of(context).unfocus();
    final result = await showStationFilterSheet(context, _filters);
    if (result != null && mounted) setState(() => _filters = result);
  }

  void _selectSuggestion(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final showDiscovery = _controller.text.trim().isEmpty && !_filters.isActive;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('SEARCH RADIO'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 16),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Find your frequency.',
                  style: AppTextStyles.bodyLarge,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: SearchBar(
                  controller: _controller,
                  focusNode: _focusNode,
                  hintText: 'Station, country, genre or language',
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (_controller.text.isNotEmpty)
                      IconButton(
                        tooltip: 'Clear search',
                        onPressed: _controller.clear,
                        icon: const Icon(Icons.close),
                      ),
                  ],
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    if (!showDiscovery)
                      Expanded(
                        child: Text(
                          '${_results.length} STATIONS FOUND',
                          style: AppTextStyles.caption,
                        ),
                      )
                    else
                      const Spacer(),
                    OutlinedButton.icon(
                      onPressed: _openFilters,
                      icon: Icon(
                        _filters.isActive
                            ? Icons.filter_alt
                            : Icons.filter_alt_outlined,
                      ),
                      label: Text(_filters.isActive ? 'FILTER · ON' : 'FILTER'),
                    ),
                  ],
                ),
              ),
            ),
            if (_filters.isActive)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                sliver: SliverToBoxAdapter(
                  child: _ActiveFilters(
                    filters: _filters,
                    onChanged: (value) => setState(() => _filters = value),
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              sliver: SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(0, .02),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: showDiscovery
                      ? _Suggestions(
                          key: const ValueKey('suggestions'),
                          recent: _recent,
                          trending: _trending,
                          onSelected: _selectSuggestion,
                        )
                      : _results.isEmpty
                      ? const SearchEmptyState(key: ValueKey('empty'))
                      : _ResultList(
                          key: const ValueKey('results'),
                          stations: _results,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({
    required this.recent,
    required this.trending,
    required this.onSelected,
    super.key,
  });
  final List<String> recent;
  final List<String> trending;
  final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      _SuggestionSection(
        title: 'RECENT SEARCHES',
        icon: Icons.history,
        values: recent,
        onSelected: onSelected,
      ),
      const SizedBox(height: 28),
      _SuggestionSection(
        title: 'TRENDING SEARCHES',
        icon: Icons.trending_up,
        values: trending,
        onSelected: onSelected,
      ),
      const SizedBox(height: 28),
      _SuggestionSection(
        title: 'SUGGESTED GENRES',
        icon: Icons.graphic_eq,
        values: const ['Jazz', 'Rock', 'Pop', 'Electronic'],
        onSelected: onSelected,
      ),
      const SizedBox(height: 28),
      _SuggestionSection(
        title: 'SUGGESTED COUNTRIES',
        icon: Icons.public,
        values: const ['Japan', 'France', 'Australia', 'South Korea'],
        onSelected: onSelected,
      ),
    ],
  );
}

class _SuggestionSection extends StatelessWidget {
  const _SuggestionSection({
    required this.title,
    required this.icon,
    required this.values,
    required this.onSelected,
  });
  final String title;
  final IconData icon;
  final List<String> values;
  final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: AppTextStyles.headingMedium),
      const SizedBox(height: 8),
      for (final value in values)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon),
          title: Text(value),
          trailing: const Icon(Icons.north_west, size: 18),
          onTap: () => onSelected(value),
        ),
    ],
  );
}

class _ResultList extends StatelessWidget {
  const _ResultList({required this.stations, super.key});
  final List<StationPreview> stations;
  @override
  Widget build(BuildContext context) => ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: stations.length,
    separatorBuilder: (_, _) => const SizedBox(height: 10),
    itemBuilder: (_, index) => SearchResultTile(station: stations[index]),
  );
}

class _ActiveFilters extends StatelessWidget {
  const _ActiveFilters({required this.filters, required this.onChanged});
  final StationFilters filters;
  final ValueChanged<StationFilters> onChanged;
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      if (filters.country != null)
        _chip(
          filters.country!,
          () => onChanged(filters.copyWith(clearCountry: true)),
        ),
      if (filters.genre != null)
        _chip(
          filters.genre!,
          () => onChanged(filters.copyWith(clearGenre: true)),
        ),
      if (filters.language != null)
        _chip(
          filters.language!,
          () => onChanged(filters.copyWith(clearLanguage: true)),
        ),
      if (filters.liveOnly)
        _chip('LIVE ONLY', () => onChanged(filters.copyWith(liveOnly: false))),
    ],
  );
  Widget _chip(String label, VoidCallback remove) => InputChip(
    label: Text(label.toUpperCase()),
    onDeleted: remove,
    backgroundColor: AppColors.surfaceElevated,
    side: const BorderSide(color: AppColors.border),
  );
}
