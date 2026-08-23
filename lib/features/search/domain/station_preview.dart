class StationPreview {
  const StationPreview({
    required this.id,
    required this.stationName,
    required this.country,
    required this.countryCode,
    required this.city,
    required this.genre,
    required this.language,
    this.frequency,
    this.isLive = true,
  });

  final String id;
  final String stationName;
  final String country;
  final String countryCode;
  final String city;
  final String genre;
  final String language;
  final String? frequency;
  final bool isLive;

  bool matches(String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) return true;
    return [
      stationName,
      country,
      countryCode,
      city,
      genre,
      language,
    ].any((value) => value.toLowerCase().contains(needle));
  }
}
