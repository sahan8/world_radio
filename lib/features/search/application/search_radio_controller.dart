import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../stations/data/radio_browser_service.dart';
import '../../stations/domain/radio_station.dart';

enum SearchLoadState { idle, loading, success, empty, error, loadingMore }

class SearchRadioController extends ChangeNotifier {
  SearchRadioController(this._service);
  final RadioBrowserService _service;
  Timer? _debounce;
  int _requestId = 0;
  String _query = '';
  String? _countryCode;
  String? _genre;
  String? _language;
  SearchLoadState state = SearchLoadState.idle;
  List<RadioStation> stations = const [];
  bool hasMore = true;

  static const countryCodes = {
    'Sri Lanka': 'LK',
    'Japan': 'JP',
    'South Korea': 'KR',
    'United Kingdom': 'GB',
    'United States': 'US',
    'France': 'FR',
    'Australia': 'AU',
    'Germany': 'DE',
    'Brazil': 'BR',
    'Canada': 'CA',
  };
  static const knownGenres = {
    'pop',
    'rock',
    'jazz',
    'electronic',
    'news',
    'talk',
    'chill',
    'classical',
  };
  static const knownLanguages = {
    'english',
    'sinhala',
    'japanese',
    'korean',
    'french',
    'spanish',
    'german',
  };

  void update(
    String query, {
    String? country,
    String? genre,
    String? language,
  }) {
    // Invalidate an in-flight response immediately, including when the query
    // is cleared before the next debounced request starts.
    _requestId++;
    _query = query.trim();
    _countryCode = countryCodes[country];
    _genre = genre;
    _language = language;
    _debounce?.cancel();
    if (_query.isEmpty &&
        _countryCode == null &&
        _genre == null &&
        _language == null) {
      state = SearchLoadState.idle;
      stations = const [];
      notifyListeners();
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), search);
  }

  Future<void> search() async {
    final request = ++_requestId;
    state = SearchLoadState.loading;
    if (request == _requestId) notifyListeners();
    try {
      final values = await _fetch(offset: 0);
      if (request != _requestId) return;
      stations = _unique(values);
      hasMore = values.length >= 20;
      state = stations.isEmpty
          ? SearchLoadState.empty
          : SearchLoadState.success;
    } on RadioBrowserException {
      if (request != _requestId) return;
      state = SearchLoadState.error;
    }
    if (request == _requestId) notifyListeners();
  }

  Future<void> loadMore() async {
    if (!hasMore ||
        state == SearchLoadState.loadingMore ||
        state == SearchLoadState.loading) {
      return;
    }
    final request = _requestId;
    state = SearchLoadState.loadingMore;
    notifyListeners();
    try {
      final values = await _fetch(offset: stations.length);
      if (request != _requestId) return;
      stations = _unique([...stations, ...values]);
      hasMore = values.length >= 20;
      state = SearchLoadState.success;
    } on RadioBrowserException {
      if (request == _requestId) state = SearchLoadState.success;
    }
    notifyListeners();
  }

  Future<List<RadioStation>> _fetch({required int offset}) {
    final lower = _query.toLowerCase();
    final inferredCountry = countryCodes.entries
        .where((entry) => entry.key.toLowerCase() == lower)
        .map((entry) => entry.value)
        .firstOrNull;
    final inferredGenre = knownGenres.contains(lower) ? lower : null;
    final inferredLanguage = knownLanguages.contains(lower) ? lower : null;
    final useName =
        inferredCountry == null &&
        inferredGenre == null &&
        inferredLanguage == null;
    return _service.searchStations(
      name: useName && _query.isNotEmpty ? _query : null,
      countryCode: _countryCode ?? inferredCountry,
      tag: _genre ?? inferredGenre,
      language: _language ?? inferredLanguage,
      offset: offset,
    );
  }

  List<RadioStation> _unique(List<RadioStation> values) => [
    ...{for (final station in values) station.stationUuid: station}.values,
  ];
  @override
  void dispose() {
    _debounce?.cancel();
    _service.close();
    super.dispose();
  }
}
