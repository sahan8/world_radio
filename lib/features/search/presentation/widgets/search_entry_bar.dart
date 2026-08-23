import 'package:flutter/material.dart';

import '../search_screen.dart';

class SearchEntryBar extends StatelessWidget {
  const SearchEntryBar({
    super.key,
    this.hint = 'Search stations, countries, genres...',
  });

  final String hint;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Open radio search',
    child: SearchBar(
      hintText: hint,
      leading: const Icon(Icons.search),
      onTap: () => Navigator.of(context).push(SearchScreen.route()),
      onChanged: (_) => Navigator.of(context).push(SearchScreen.route()),
    ),
  );
}
