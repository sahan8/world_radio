import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../../stations/domain/radio_station.dart';

abstract interface class LocalStorageService {
  Future<List<RadioStation>> loadFavorites();
  Future<void> saveFavorites(List<RadioStation> stations);
  Future<List<RadioStation>> loadRecentStations();
  Future<void> saveRecentStations(List<RadioStation> stations);
  Future<RadioStation?> loadLastStation();
  Future<void> saveLastStation(RadioStation station);
  Future<void> clearHistory();
}

class InMemoryLocalStorageService implements LocalStorageService {
  List<RadioStation> _favorites = const [];
  List<RadioStation> _recent = const [];
  RadioStation? _last;
  @override
  Future<List<RadioStation>> loadFavorites() async => [..._favorites];
  @override
  Future<void> saveFavorites(List<RadioStation> stations) async =>
      _favorites = [...stations];
  @override
  Future<List<RadioStation>> loadRecentStations() async => [..._recent];
  @override
  Future<void> saveRecentStations(List<RadioStation> stations) async =>
      _recent = [...stations];
  @override
  Future<RadioStation?> loadLastStation() async => _last;
  @override
  Future<void> saveLastStation(RadioStation station) async => _last = station;
  @override
  Future<void> clearHistory() async => _recent = const [];
}

class SharedPreferencesLocalStorageService implements LocalStorageService {
  SharedPreferencesLocalStorageService({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();
  final SharedPreferencesAsync _preferences;

  @override
  Future<List<RadioStation>> loadFavorites() =>
      _loadList(StorageKeys.favorites);
  @override
  Future<void> saveFavorites(List<RadioStation> stations) =>
      _saveList(StorageKeys.favorites, stations);
  @override
  Future<List<RadioStation>> loadRecentStations() =>
      _loadList(StorageKeys.recentStations);
  @override
  Future<void> saveRecentStations(List<RadioStation> stations) =>
      _saveList(StorageKeys.recentStations, stations);

  @override
  Future<RadioStation?> loadLastStation() async {
    try {
      final value = await _preferences.getString(StorageKeys.lastStation);
      return value == null
          ? null
          : RadioStation.fromJson(jsonDecode(value) as Map<String, dynamic>);
    } catch (error) {
      debugPrint('Last station could not be restored: $error');
      await _preferences.remove(StorageKeys.lastStation);
      return null;
    }
  }

  @override
  Future<void> saveLastStation(RadioStation station) => _preferences.setString(
    StorageKeys.lastStation,
    jsonEncode(station.toJson()),
  );
  @override
  Future<void> clearHistory() async {
    await _preferences.remove(StorageKeys.recentStations);
  }

  Future<List<RadioStation>> _loadList(String key) async {
    try {
      final values = await _preferences.getStringList(key) ?? const [];
      final stations = <RadioStation>[];
      var foundCorruption = false;
      for (final value in values) {
        try {
          stations.add(
            RadioStation.fromJson(jsonDecode(value) as Map<String, dynamic>),
          );
        } catch (error) {
          foundCorruption = true;
          debugPrint('Skipping corrupt saved station: $error');
        }
      }
      if (foundCorruption) await _saveList(key, stations);
      return stations;
    } catch (error) {
      debugPrint('Local station list could not be loaded: $error');
      return const [];
    }
  }

  Future<void> _saveList(String key, List<RadioStation> stations) async {
    try {
      await _preferences.setStringList(
        key,
        stations
            .map((station) => jsonEncode(station.toJson()))
            .toList(growable: false),
      );
    } catch (error) {
      debugPrint('Local station list could not be saved: $error');
    }
  }
}
