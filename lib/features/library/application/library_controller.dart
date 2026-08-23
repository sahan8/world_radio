import 'package:flutter/widgets.dart';

import '../../stations/domain/radio_station.dart';
import '../data/local_storage_service.dart';

class LibraryController extends ChangeNotifier {
  LibraryController(this._storage);
  static const recentLimit = 20;
  final LocalStorageService _storage;
  List<RadioStation> _favorites = const [];
  List<RadioStation> _recent = const [];
  RadioStation? _lastStation;
  bool _loaded = false;

  List<RadioStation> get favorites => List.unmodifiable(_favorites);
  List<RadioStation> get recentStations => List.unmodifiable(_recent);
  RadioStation? get lastStation => _lastStation;
  bool get loaded => _loaded;
  bool isFavorite(String stationUuid) =>
      _favorites.any((station) => station.id == stationUuid);

  Future<void> load() async {
    final values = await Future.wait([
      _storage.loadFavorites(),
      _storage.loadRecentStations(),
    ]);
    _favorites = _unique(values[0]);
    _recent = _unique(values[1]).take(recentLimit).toList(growable: false);
    _lastStation = await _storage.loadLastStation();
    _loaded = true;
    notifyListeners();
  }

  Future<void> toggleFavorite(RadioStation station) async {
    if (isFavorite(station.id)) {
      _favorites = _favorites
          .where((item) => item.id != station.id)
          .toList(growable: false);
    } else {
      _favorites = [station, ..._favorites];
    }
    notifyListeners();
    await _storage.saveFavorites(_favorites);
  }

  Future<void> recordPlayed(RadioStation station) async {
    if (_recent.firstOrNull?.id == station.id &&
        _lastStation?.id == station.id) {
      return;
    }
    _recent = [
      station,
      ..._recent.where((item) => item.id != station.id),
    ].take(recentLimit).toList(growable: false);
    _lastStation = station;
    notifyListeners();
    await Future.wait([
      _storage.saveRecentStations(_recent),
      _storage.saveLastStation(station),
    ]);
  }

  Future<void> clearHistory() async {
    _recent = const [];
    notifyListeners();
    await _storage.clearHistory();
  }

  List<RadioStation> _unique(List<RadioStation> values) => [
    ...{for (final station in values) station.id: station}.values,
  ];
}

class LibraryScope extends InheritedNotifier<LibraryController> {
  const LibraryScope({
    required LibraryController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);
  static LibraryController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LibraryScope>();
    assert(scope != null, 'LibraryScope not found');
    return scope!.notifier!;
  }
}
