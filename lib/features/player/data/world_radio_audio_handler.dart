import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class WorldRadioAudioHandler extends BaseAudioHandler with QueueHandler {
  WorldRadioAudioHandler({AudioPlayer? player})
    : _player =
          player ??
          AudioPlayer(
            userAgent: 'WorldRadio/1.0 Flutter',
            useProxyForRequestHeaders: false,
          ) {
    _playerStateSubscription = _player.playerStateStream.listen(
      _broadcastState,
    );
    _errorSubscription = _player.errorStream.listen(_onError);
    _configureSession();
  }

  final AudioPlayer _player;
  late final StreamSubscription<PlayerState> _playerStateSubscription;
  late final StreamSubscription<PlayerException> _errorSubscription;
  StreamSubscription<void>? _noisySubscription;
  int _generation = 0;
  bool _disposed = false;

  Future<void> _configureSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration.music());
      if (_disposed) return;
      _noisySubscription = session.becomingNoisyEventStream.listen(
        (_) => pause(),
      );
    } catch (error) {
      debugPrint('Audio session configuration failed: $error');
    }
  }

  @override
  Future<void> playMediaItem(MediaItem mediaItem) async {
    final rawUrl = mediaItem.extras?['streamUrl']?.toString() ?? '';
    final generation = ++_generation;
    this.mediaItem.add(mediaItem);
    _publishLoading();
    try {
      final uri = _validatedUri(rawUrl);
      await _player.stop();
      await _player
          .setUrl(uri.toString())
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () =>
                throw TimeoutException('Stream preparation timed out'),
          );
      if (generation != _generation) {
        return;
      }
      _player.play();
    } on PlayerInterruptedException {
      if (generation == _generation) {
        _publishError();
      }
    } catch (error) {
      if (generation != _generation) {
        return;
      }
      final host = Uri.tryParse(rawUrl)?.host ?? 'invalid URL';
      debugPrint('Radio stream failed: ${mediaItem.title} $host ($error)');
      _publishError();
    }
  }

  @override
  Future<void> play() async {
    final item = mediaItem.valueOrNull;
    if (item == null) return;
    if (_player.processingState == ProcessingState.idle ||
        _player.processingState == ProcessingState.completed) {
      await playMediaItem(item);
    } else {
      _player.play();
    }
  }

  @override
  Future<void> pause() async {
    _generation++;
    await _player.pause();
    _broadcastState(_player.playerState);
  }

  @override
  Future<void> stop() async {
    _generation++;
    await _player.stop();
    playbackState.add(
      playbackState.value.copyWith(
        controls: const [],
        processingState: AudioProcessingState.idle,
        playing: false,
      ),
    );
  }

  @override
  Future<void> skipToNext() async {
    final index = _queueIndex;
    if (index >= 0 && index < queue.value.length - 1) {
      await playMediaItem(queue.value[index + 1]);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    final index = _queueIndex;
    if (index > 0) await playMediaItem(queue.value[index - 1]);
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    this.queue.add(queue);
    _broadcastState(_player.playerState);
  }

  @override
  Future<dynamic> customAction(
    String name, [
    Map<String, dynamic>? extras,
  ]) async {
    if (name == 'setVolume') {
      final value = extras?['value'];
      if (value is num) await _player.setVolume(value.toDouble().clamp(0, 1));
    }
    return super.customAction(name, extras);
  }

  int get _queueIndex {
    final id = mediaItem.valueOrNull?.id;
    return id == null ? -1 : queue.value.indexWhere((item) => item.id == id);
  }

  void _broadcastState(PlayerState state) {
    final processing = switch (state.processingState) {
      ProcessingState.idle => AudioProcessingState.idle,
      ProcessingState.loading => AudioProcessingState.loading,
      ProcessingState.buffering => AudioProcessingState.buffering,
      ProcessingState.ready => AudioProcessingState.ready,
      ProcessingState.completed => AudioProcessingState.error,
    };
    final previous = _queueIndex > 0;
    final next = _queueIndex >= 0 && _queueIndex < queue.value.length - 1;
    final controls = <MediaControl>[
      if (previous) MediaControl.skipToPrevious,
      state.playing ? MediaControl.pause : MediaControl.play,
      if (next) MediaControl.skipToNext,
      MediaControl.stop,
    ];
    playbackState.add(
      PlaybackState(
        controls: controls,
        androidCompactActionIndices: [
          for (var i = 0; i < controls.length && i < 3; i++) i,
        ],
        processingState: processing,
        playing: state.playing && processing == AudioProcessingState.ready,
        queueIndex: _queueIndex < 0 ? null : _queueIndex,
      ),
    );
  }

  void _publishLoading() => playbackState.add(
    playbackState.value.copyWith(
      processingState: AudioProcessingState.loading,
      playing: false,
    ),
  );
  void _publishError() => playbackState.add(
    playbackState.value.copyWith(
      processingState: AudioProcessingState.error,
      playing: false,
    ),
  );
  void _onError(PlayerException error) {
    debugPrint('Radio playback error ${error.code}: ${error.message}');
    _publishError();
  }

  Uri _validatedUri(String rawUrl) {
    final uri = Uri.tryParse(rawUrl.trim());
    if (uri == null ||
        !uri.hasAuthority ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      throw const FormatException('Invalid radio stream URL');
    }
    return uri;
  }

  Future<void> disposeHandler() async {
    if (_disposed) return;
    _disposed = true;
    _generation++;
    await _noisySubscription?.cancel();
    await _playerStateSubscription.cancel();
    await _errorSubscription.cancel();
    await _player.dispose();
  }
}
