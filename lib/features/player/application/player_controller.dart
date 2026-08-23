import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/widgets.dart';

import '../../stations/domain/radio_station.dart';
import '../../library/application/library_controller.dart';

class PlayerController extends ChangeNotifier {
  PlayerController(this._handler, this._library) {
    _playbackSubscription = _handler.playbackState.listen(_onPlaybackState);
    _mediaSubscription = _handler.mediaItem.listen(_onMediaItem);
  }

  final AudioHandler _handler;
  final LibraryController _library;
  late final StreamSubscription<PlaybackState> _playbackSubscription;
  late final StreamSubscription<MediaItem?> _mediaSubscription;
  final Map<String, RadioStation> _stationsById = {};
  RadioStation? _currentStation;
  List<RadioStation> _queue = const [];
  PlaybackState _playbackState = PlaybackState();
  double _volume = .72;
  String _sleepTimer = 'Off';

  RadioStation? get currentStation => _currentStation;
  String get streamUrl => _currentStation?.streamUrl ?? '';
  bool get isPlaying => _playbackState.playing;
  bool get isLoading =>
      _playbackState.processingState == AudioProcessingState.loading ||
      _playbackState.processingState == AudioProcessingState.buffering;
  bool get hasError =>
      _playbackState.processingState == AudioProcessingState.error;
  bool get canPrevious => _queueIndex > 0;
  bool get canNext => _queueIndex >= 0 && _queueIndex < _queue.length - 1;
  double get volume => _volume;
  String get sleepTimer => _sleepTimer;
  int get _queueIndex => _currentStation == null
      ? -1
      : _queue.indexWhere((station) => station.id == _currentStation!.id);

  Future<void> select(
    RadioStation station, {
    bool play = true,
    List<RadioStation>? queue,
  }) async {
    _currentStation = station;
    if (queue != null) _queue = _unique(queue);
    if (_queue.every((item) => item.id != station.id)) {
      _queue = [..._queue, station];
    }
    for (final item in _queue) {
      _stationsById[item.id] = item;
    }
    _stationsById[station.id] = station;
    await _handler.updateQueue(
      _queue.map(_toMediaItem).toList(growable: false),
    );
    notifyListeners();
    if (play) await _handler.playMediaItem(_toMediaItem(station));
  }

  Future<void> togglePlaying() async {
    if (_currentStation == null) return;
    if (isPlaying || isLoading) {
      await _handler.pause();
    } else if (hasError ||
        _playbackState.processingState == AudioProcessingState.idle) {
      await retry();
    } else {
      await _handler.play();
    }
  }

  Future<void> retry() async {
    final station = _currentStation;
    if (station != null) await _handler.playMediaItem(_toMediaItem(station));
  }

  Future<void> next() => canNext ? _handler.skipToNext() : Future.value();
  Future<void> previous() =>
      canPrevious ? _handler.skipToPrevious() : Future.value();

  Future<void> setVolume(double value) async {
    _volume = value.clamp(0, 1);
    notifyListeners();
    await _handler.customAction('setVolume', {'value': _volume});
  }

  void setSleepTimer(String value) {
    _sleepTimer = value;
    notifyListeners();
  }

  MediaItem _toMediaItem(RadioStation station) => MediaItem(
    id: station.id,
    title: station.name,
    artist: [
      station.displayCountry,
      if (station.city.isNotEmpty) station.city,
      station.primaryGenre,
    ].join(' · '),
    album: 'World Radio · LIVE',
    artUri: station.hasArtwork ? Uri.tryParse(station.favicon) : null,
    extras: {
      'streamUrl': station.streamUrl,
      'country': station.displayCountry,
      'genre': station.primaryGenre,
      'language': station.primaryLanguage,
      'codec': station.codec,
      'bitrate': station.bitrate,
      'hls': station.hls,
      'live': true,
    },
  );

  void _onPlaybackState(PlaybackState state) {
    _playbackState = state;
    notifyListeners();
  }

  void _onMediaItem(MediaItem? item) {
    if (item == null) return;
    final station = _stationsById[item.id];
    if (station != null) {
      _currentStation = station;
      _library.recordPlayed(station);
      notifyListeners();
    }
  }

  void restore(RadioStation station) {
    _currentStation = station;
    _queue = [station];
    _stationsById[station.id] = station;
    notifyListeners();
  }

  List<RadioStation> _unique(List<RadioStation> stations) => [
    ...{for (final station in stations) station.id: station}.values,
  ];

  @override
  void dispose() {
    _playbackSubscription.cancel();
    _mediaSubscription.cancel();
    super.dispose();
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
