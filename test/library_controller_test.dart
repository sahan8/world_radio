import 'package:flutter_test/flutter_test.dart';
import 'package:world_radio/features/library/application/library_controller.dart';
import 'package:world_radio/features/library/data/local_storage_service.dart';
import 'package:world_radio/features/stations/domain/radio_station.dart';

void main() {
  test('favorites persist without duplicates and can be removed', () async {
    final storage = _MemoryStorage();
    final library = LibraryController(storage);
    await library.load();
    final station = _station(1);

    await library.toggleFavorite(station);
    await library.toggleFavorite(station);
    await library.toggleFavorite(station);

    final restored = LibraryController(storage);
    await restored.load();
    expect(restored.favorites.map((item) => item.id), [station.id]);

    await restored.toggleFavorite(station);
    final afterRemoval = LibraryController(storage);
    await afterRemoval.load();
    expect(afterRemoval.favorites, isEmpty);
  });

  test('recents reorder, deduplicate, persist, and remain bounded', () async {
    final storage = _MemoryStorage();
    final library = LibraryController(storage);
    await library.load();
    for (var index = 0; index < 24; index++) {
      await library.recordPlayed(_station(index));
    }
    await library.recordPlayed(_station(10));

    expect(library.recentStations.length, LibraryController.recentLimit);
    expect(library.recentStations.first.id, 'station-10');
    expect(
      library.recentStations.map((item) => item.id).toSet().length,
      LibraryController.recentLimit,
    );

    final restored = LibraryController(storage);
    await restored.load();
    expect(restored.lastStation?.id, 'station-10');
    expect(restored.recentStations.first.id, 'station-10');

    await restored.clearHistory();
    expect(restored.recentStations, isEmpty);
  });
}

RadioStation _station(int index) => RadioStation(
  stationUuid: 'station-$index',
  name: 'Station $index',
  url: 'https://example.com/$index',
  urlResolved: 'https://example.com/$index',
  homepage: '',
  favicon: '',
  tags: const ['radio'],
  country: 'Testland',
  countryCode: 'TS',
  state: 'Test City',
  language: 'English',
  languageCodes: const ['eng'],
  codec: 'MP3',
  bitrate: 128,
  votes: 0,
  clickCount: 0,
  clickTrend: 0,
  lastCheckOk: true,
  lastCheckTime: null,
  geoLat: null,
  geoLong: null,
  hls: false,
);

class _MemoryStorage implements LocalStorageService {
  List<RadioStation> favorites = [];
  List<RadioStation> recent = [];
  RadioStation? last;
  @override
  Future<void> clearHistory() async => recent = [];
  @override
  Future<List<RadioStation>> loadFavorites() async => [...favorites];
  @override
  Future<RadioStation?> loadLastStation() async => last;
  @override
  Future<List<RadioStation>> loadRecentStations() async => [...recent];
  @override
  Future<void> saveFavorites(List<RadioStation> stations) async =>
      favorites = [...stations];
  @override
  Future<void> saveLastStation(RadioStation station) async => last = station;
  @override
  Future<void> saveRecentStations(List<RadioStation> stations) async =>
      recent = [...stations];
}
