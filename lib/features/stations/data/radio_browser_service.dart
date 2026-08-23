import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/api/radio_api_config.dart';
import '../domain/radio_station.dart';

class RadioBrowserException implements Exception {
  const RadioBrowserException();
}

class RadioBrowserService {
  RadioBrowserService({http.Client? client, Uri? baseUri})
    : _client = client ?? http.Client(),
      _baseUri = baseUri ?? Uri.parse(RadioApiConfig.baseUrl);
  final http.Client _client;
  final Uri _baseUri;

  Future<List<RadioStation>> getPopularStations({
    int limit = 15,
    int offset = 0,
  }) => searchStations(
    limit: limit,
    offset: offset,
    order: 'clickcount',
    reverse: true,
  );

  Future<List<RadioStation>> searchStations({
    String? name,
    String? countryCode,
    String? language,
    String? tag,
    int limit = RadioApiConfig.pageSize,
    int offset = 0,
    String order = 'clickcount',
    bool reverse = true,
  }) async {
    final query = <String, String>{
      if (name?.trim().isNotEmpty ?? false) 'name': name!.trim(),
      if (countryCode?.trim().isNotEmpty ?? false)
        'countrycode': countryCode!.trim().toUpperCase(),
      if (language?.trim().isNotEmpty ?? false)
        'language': language!.trim().toLowerCase(),
      if (tag?.trim().isNotEmpty ?? false) 'tag': tag!.trim().toLowerCase(),
      'hidebroken': 'true',
      'limit': '$limit',
      'offset': '$offset',
      'order': order,
      'reverse': '$reverse',
    };
    final uri = _baseUri.replace(
      path: '/json/stations/search',
      queryParameters: query,
    );
    try {
      final response = await _client
          .get(uri, headers: RadioApiConfig.headers)
          .timeout(RadioApiConfig.timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw const RadioBrowserException();
      }
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! List) throw const RadioBrowserException();
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(RadioStation.fromJson)
          .where(
            (station) =>
                station.stationUuid.isNotEmpty && station.name.isNotEmpty,
          )
          .toList(growable: false);
    } on TimeoutException {
      throw const RadioBrowserException();
    } on FormatException {
      throw const RadioBrowserException();
    } on http.ClientException {
      throw const RadioBrowserException();
    }
  }

  Future<List<RadioStation>> getStationsByCountryCode(
    String code, {
    int limit = RadioApiConfig.pageSize,
    int offset = 0,
  }) => searchStations(countryCode: code, limit: limit, offset: offset);
  Future<List<RadioStation>> getStationsByTag(
    String tag, {
    int limit = RadioApiConfig.pageSize,
    int offset = 0,
  }) => searchStations(tag: tag, limit: limit, offset: offset);
  Future<List<RadioStation>> getStationsByLanguage(
    String language, {
    int limit = RadioApiConfig.pageSize,
    int offset = 0,
  }) => searchStations(language: language, limit: limit, offset: offset);
  void close() => _client.close();
}
