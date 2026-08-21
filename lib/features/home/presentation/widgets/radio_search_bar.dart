import 'package:flutter/material.dart';

class RadioSearchBar extends StatelessWidget {
  const RadioSearchBar({super.key});

  @override
  Widget build(BuildContext context) => const TextField(
    textInputAction: TextInputAction.search,
    decoration: InputDecoration(
      hintText: 'Search stations, countries, genres...',
      prefixIcon: Icon(Icons.search, semanticLabel: 'Search'),
    ),
  );
}
