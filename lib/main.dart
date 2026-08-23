import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'features/player/data/world_radio_audio_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final audioHandler = await AudioService.init(
    builder: WorldRadioAudioHandler.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.world_radio.audio',
      androidNotificationChannelName: 'World Radio playback',
      androidNotificationChannelDescription: 'Live radio playback controls',
      androidNotificationOngoing: false,
      androidStopForegroundOnPause: false,
    ),
  );
  runApp(WorldRadioApp(audioHandler: audioHandler));
}
