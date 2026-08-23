import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_text_styles.dart';

class StationFilters {
  const StationFilters({
    this.country,
    this.genre,
    this.language,
    this.liveOnly = false,
  });
  final String? country;
  final String? genre;
  final String? language;
  final bool liveOnly;
  bool get isActive =>
      country != null || genre != null || language != null || liveOnly;
  StationFilters copyWith({
    String? country,
    String? genre,
    String? language,
    bool? liveOnly,
    bool clearCountry = false,
    bool clearGenre = false,
    bool clearLanguage = false,
  }) => StationFilters(
    country: clearCountry ? null : country ?? this.country,
    genre: clearGenre ? null : genre ?? this.genre,
    language: clearLanguage ? null : language ?? this.language,
    liveOnly: liveOnly ?? this.liveOnly,
  );
}

Future<StationFilters?> showStationFilterSheet(
  BuildContext context,
  StationFilters initial,
) => showModalBottomSheet<StationFilters>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _FilterSheet(initial: initial),
);

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial});
  final StationFilters initial;
  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late StationFilters value = widget.initial;
  static const countries = [
    'Sri Lanka',
    'Japan',
    'South Korea',
    'United Kingdom',
    'United States',
    'France',
    'Australia',
  ];
  static const genres = [
    'Pop',
    'Rock',
    'Jazz',
    'Electronic',
    'News',
    'Talk',
    'Chill',
  ];
  static const languages = [
    'English',
    'Sinhala',
    'Japanese',
    'Korean',
    'French',
    'Spanish',
  ];

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
    expand: false,
    initialChildSize: .82,
    minChildSize: .5,
    maxChildSize: .94,
    builder: (context, controller) => Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'FILTER STATIONS',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              IconButton(
                tooltip: 'Close filters',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            children: [
              _section(
                'COUNTRY',
                countries,
                value.country,
                (v) => setState(
                  () => value = value.copyWith(
                    country: v,
                    clearCountry: v == null,
                  ),
                ),
              ),
              _section(
                'GENRE',
                genres,
                value.genre,
                (v) => setState(
                  () => value = value.copyWith(genre: v, clearGenre: v == null),
                ),
              ),
              _section(
                'LANGUAGE',
                languages,
                value.language,
                (v) => setState(
                  () => value = value.copyWith(
                    language: v,
                    clearLanguage: v == null,
                  ),
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('LIVE ONLY', style: AppTextStyles.title),
                value: value.liveOnly,
                onChanged: (v) =>
                    setState(() => value = value.copyWith(liveOnly: v)),
              ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        setState(() => value = const StationFilters()),
                    child: const Text('RESET'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(context, value);
                    },
                    child: const Text('APPLY FILTERS'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _section(
    String title,
    List<String> options,
    String? selected,
    ValueChanged<String?> changed,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 22),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.title),
        const SizedBox(height: 8),
        RadioGroup<String?>(
          groupValue: selected,
          onChanged: changed,
          child: Column(
            children: [
              RadioListTile<String?>(
                contentPadding: EdgeInsets.zero,
                title: const Text('All'),
                value: null,
              ),
              for (final option in options)
                RadioListTile<String?>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(option),
                  value: option,
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
