import '../../../core/security/safe_uri.dart';

class RadioStation {
  const RadioStation({
    required this.stationUuid,
    required this.name,
    required this.url,
    required this.urlResolved,
    required this.homepage,
    required this.favicon,
    required this.tags,
    required this.country,
    required this.countryCode,
    required this.state,
    required this.language,
    required this.languageCodes,
    required this.codec,
    required this.bitrate,
    required this.votes,
    required this.clickCount,
    required this.clickTrend,
    required this.lastCheckOk,
    required this.lastCheckTime,
    required this.geoLat,
    required this.geoLong,
    required this.hls,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) => RadioStation(
    stationUuid: _string(json['stationuuid']),
    name: _string(json['name'], fallback: 'Unknown station'),
    url: _validUrl(json['url']),
    urlResolved: _validUrl(json['url_resolved']),
    homepage: _validUrl(json['homepage']),
    favicon: _validUrl(json['favicon']),
    tags: _list(json['tags']),
    country: _string(json['country']),
    countryCode: _string(json['countrycode']).toUpperCase(),
    state: _string(json['state']),
    language: _string(json['language']),
    languageCodes: _list(json['languagecodes']),
    codec: _string(json['codec']).toUpperCase(),
    bitrate: _integer(json['bitrate']),
    votes: _integer(json['votes']),
    clickCount: _integer(json['clickcount']),
    clickTrend: _integer(json['clicktrend']),
    lastCheckOk: _boolean(json['lastcheckok']),
    lastCheckTime: DateTime.tryParse(_string(json['lastchecktime_iso8601'])),
    geoLat: _double(json['geo_lat']),
    geoLong: _double(json['geo_long']),
    hls: _boolean(json['hls']),
  );

  final String stationUuid;
  final String name;
  final String url;
  final String urlResolved;
  final String homepage;
  final String favicon;
  final List<String> tags;
  final String country;
  final String countryCode;
  final String state;
  final String language;
  final List<String> languageCodes;
  final String codec;
  final int bitrate;
  final int votes;
  final int clickCount;
  final int clickTrend;
  final bool lastCheckOk;
  final DateTime? lastCheckTime;
  final double? geoLat;
  final double? geoLong;
  final bool hls;

  Map<String, dynamic> toJson() => {
    'schema': 1,
    'stationuuid': stationUuid,
    'name': name,
    'url': url,
    'url_resolved': urlResolved,
    'favicon': favicon,
    'tags': tags.join(','),
    'country': country,
    'countrycode': countryCode,
    'state': state,
    'language': language,
    'languagecodes': languageCodes.join(','),
    'codec': codec,
    'bitrate': bitrate,
    'lastcheckok': lastCheckOk ? 1 : 0,
    'hls': hls ? 1 : 0,
  };

  String get id => stationUuid;
  String get stationName => name;
  String get city => state;
  String get genre => primaryGenre;
  String? get frequency => null;
  bool get isLive => isWorking;
  bool get isWorking => lastCheckOk;
  bool get hasArtwork => favicon.isNotEmpty;
  String get displayCountry => country.isNotEmpty
      ? country
      : (countryCode.isNotEmpty ? countryCode : 'Worldwide');
  String get primaryGenre => tags.isEmpty ? 'Radio' : tags.first;
  String get primaryLanguage =>
      language.isEmpty ? 'Unknown language' : language.split(',').first.trim();
  String get streamUrl => urlResolved.isNotEmpty ? urlResolved : url;
  String get technicalSummary {
    final parts = <String>[
      if (bitrate > 0) '$bitrate kbps',
      if (codec.isNotEmpty) codec,
    ];
    return parts.isEmpty ? primaryGenre : parts.join(' · ');
  }

  static String _string(Object? value, {String fallback = ''}) {
    final result = value?.toString().trim() ?? '';
    return result.isEmpty ? fallback : result;
  }

  static int _integer(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;
  static double? _double(Object? value) =>
      value is num ? value.toDouble() : double.tryParse('$value');
  static bool _boolean(Object? value) =>
      value == true ||
      value == 1 ||
      value == '1' ||
      value?.toString().toLowerCase() == 'true';
  static List<String> _list(Object? value) =>
      (value is List ? value.map(_string) : _string(value).split(','))
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .take(8)
          .toList(growable: false);
  static String _validUrl(Object? value) {
    return SafeUri.publicHttps(value)?.toString() ?? '';
  }
}
