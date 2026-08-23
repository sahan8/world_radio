import 'package:flutter/widgets.dart';

import '../../search/data/placeholder_stations.dart';
import '../../search/domain/station_preview.dart';

class PlayerController extends ChangeNotifier {
  StationPreview? _currentStation;
  bool _isPlaying = false;
  double _volume = .72;
  final Set<String> _favorites = {};
  String _sleepTimer = 'Off';

  StationPreview? get currentStation => _currentStation;
  bool get isPlaying => _isPlaying;
  double get volume => _volume;
  String get sleepTimer => _sleepTimer;
  bool isFavorite(StationPreview station) => _favorites.contains(station.id);

  void select(StationPreview station, {bool play = true}) {
    _currentStation = station;
    _isPlaying = play;
    notifyListeners();
  }

  void selectByName(String name) {
    final matches = placeholderStations.where(
      (station) => station.stationName.toLowerCase() == name.toLowerCase(),
    );
    select(matches.isEmpty ? placeholderStations.first : matches.first);
  }

  void togglePlaying() {
    _currentStation ??= placeholderStations.first;
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void next() => _cycle(1);
  void previous() => _cycle(-1);

  void _cycle(int offset) {
    final current = _currentStation;
    final index = current == null
        ? 0
        : placeholderStations.indexWhere((s) => s.id == current.id);
    _currentStation =
        placeholderStations[(index + offset) % placeholderStations.length];
    _isPlaying = true;
    notifyListeners();
  }

  void toggleFavorite([StationPreview? station]) {
    final target = station ?? _currentStation;
    if (target == null) return;
    _favorites.contains(target.id)
        ? _favorites.remove(target.id)
        : _favorites.add(target.id);
    notifyListeners();
  }

  void setVolume(double value) {
    _volume = value;
    notifyListeners();
  }

  void setSleepTimer(String value) {
    _sleepTimer = value;
    notifyListeners();
  }
}

class PlayerScope extends InheritedNotifier<PlayerController> {
  const PlayerScope({
    required PlayerController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static PlayerController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PlayerScope>();
    assert(scope != null, 'PlayerScope not found');
    return scope!.notifier!;
  }
}
