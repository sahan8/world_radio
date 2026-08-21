import 'package:flutter/material.dart';

enum DiscoveryCategory { countries, genres, languages }

class CountryDestination {
  const CountryDestination(this.name, this.code, this.stationCount);

  final String name;
  final String code;
  final int stationCount;
}

class GenreDestination {
  const GenreDestination(this.name, this.icon);

  final String name;
  final IconData icon;
}

class LanguageDestination {
  const LanguageDestination(this.name, this.stationCount);

  final String name;
  final int stationCount;
}

class PopularStation {
  const PopularStation(this.name, this.country, this.artworkLabel);

  final String name;
  final String country;
  final String artworkLabel;
}

abstract final class ExploreData {
  static const countries = [
    CountryDestination('Sri Lanka', 'LK', 42),
    CountryDestination('Japan', 'JP', 124),
    CountryDestination('South Korea', 'KR', 76),
    CountryDestination('United Kingdom', 'GB', 215),
    CountryDestination('United States', 'US', 640),
    CountryDestination('France', 'FR', 184),
    CountryDestination('Germany', 'DE', 196),
    CountryDestination('Australia', 'AU', 148),
    CountryDestination('Brazil', 'BR', 312),
    CountryDestination('Canada', 'CA', 226),
  ];

  static const genres = [
    GenreDestination('Pop', Icons.graphic_eq),
    GenreDestination('Rock', Icons.album_outlined),
    GenreDestination('Jazz', Icons.piano_outlined),
    GenreDestination('Electronic', Icons.memory_outlined),
    GenreDestination('Hip Hop', Icons.mic_none_outlined),
    GenreDestination('Classical', Icons.music_note_outlined),
    GenreDestination('News', Icons.newspaper_outlined),
    GenreDestination('Talk', Icons.forum_outlined),
    GenreDestination('Chill', Icons.waves_outlined),
    GenreDestination('Alternative', Icons.radio_outlined),
  ];

  static const languages = [
    LanguageDestination('English', 1240),
    LanguageDestination('Spanish', 860),
    LanguageDestination('French', 540),
    LanguageDestination('Japanese', 328),
    LanguageDestination('Korean', 212),
    LanguageDestination('German', 465),
    LanguageDestination('Portuguese', 390),
    LanguageDestination('Hindi', 276),
    LanguageDestination('Arabic', 305),
    LanguageDestination('Italian', 248),
  ];

  static const popularStations = [
    PopularStation('BBC Radio 1', 'United Kingdom', 'BBC'),
    PopularStation('Tokyo FM', 'Japan', 'TFM'),
    PopularStation('KEXP', 'United States', 'KEXP'),
    PopularStation('Triple J', 'Australia', 'JJJ'),
    PopularStation('France Inter', 'France', 'FI'),
  ];
}
