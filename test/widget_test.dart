import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:world_radio/app.dart';
import 'package:world_radio/features/home/presentation/widgets/mini_player.dart';
import 'package:world_radio/features/home/presentation/home_screen.dart';
import 'package:world_radio/features/player/application/player_controller.dart';
import 'package:world_radio/features/stations/domain/radio_station.dart';
import 'package:world_radio/widgets/controls/themed_play_button.dart';

void main() {
  testWidgets('all navigation destinations open', (tester) async {
    await tester.pumpWidget(const WorldRadioApp());
    expect(find.bySemanticsLabel('WORLD RADIO'), findsOneWidget);
    for (final destination in ['Explore', 'Search', 'Saved', 'Home']) {
      await tester.tap(find.bySemanticsLabel(destination.toUpperCase()));
      await tester.pump();
    }
    expect(find.byTooltip('Settings'), findsOneWidget);
    expect(find.bySemanticsLabel('WORLD RADIO'), findsOneWidget);
  });

  testWidgets('home sections scroll without layout errors', (tester) async {
    await tester.pumpWidget(const WorldRadioApp());

    expect(find.bySemanticsLabel('LIVE NOW'), findsOneWidget);
    expect(find.text('Search stations, countries, genres...'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1600));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.bySemanticsLabel('RECENTLY PLAYED'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('explore discovery tabs update on a narrow screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const WorldRadioApp());
    await tester.tap(find.bySemanticsLabel('EXPLORE'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('AROUND THE WORLD'), findsOneWidget);
    expect(find.bySemanticsLabel('EXPLORE'), findsWidgets);
    expect(find.text('SRI LANKA'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'initial Explore layout');

    await tester.tap(find.text('Genres'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('ELECTRONIC'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'genre layout');

    await tester.tap(find.text('Languages'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Japanese'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('invalid station exposes recoverable player error state', (
    tester,
  ) async {
    await tester.pumpWidget(const WorldRadioApp());
    PlayerScope.of(tester.element(find.byType(HomeScreen)))
        .select(_invalidStation);
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(MiniPlayer), findsOneWidget);
    expect(find.byTooltip('Retry BBC Radio 1'), findsOneWidget);

    tester
        .widget<InkWell>(find.byKey(const Key('mini-player-open')))
        .onTap
        ?.call();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('ON AIR'), findsOneWidget);
    expect(find.text('SIGNAL LOST'), findsOneWidget);
    expect(find.bySemanticsLabel('Retry station'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('approved mobile frames render without overflow', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    for (final size in const [
      Size(360, 800),
      Size(390, 844),
      Size(393, 852),
      Size(412, 915),
      Size(430, 932),
    ]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(const WorldRadioApp());
      await tester.pump(const Duration(milliseconds: 200));
      expect(tester.takeException(), isNull, reason: 'overflow at $size');
    }
  });

  testWidgets('interactive UI remains visible across brightness changes', (
    tester,
  ) async {
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    tester.platformDispatcher.textScaleFactorTestValue = 1.4;
    for (final brightness in [Brightness.dark, Brightness.light]) {
      tester.platformDispatcher.platformBrightnessTestValue = brightness;
      await tester.pumpWidget(const WorldRadioApp());
      PlayerScope.of(tester.element(find.byType(HomeScreen)))
          .select(_invalidStation);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(ThemedPlayButton), findsWidgets);
      expect(find.byTooltip('Retry BBC Radio 1'), findsOneWidget);
      expect(find.bySemanticsLabel('WORLD RADIO'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: '$brightness at 1.4x');
    }
  });

  testWidgets('settings renders and changes theme on a narrow screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const WorldRadioApp());
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('APPEARANCE'), findsOneWidget);
    expect(find.text('LOCAL DATA'), findsOneWidget);
    await tester.tap(find.text('LIGHT'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('sleep timer expires and resets its label', (tester) async {
    await tester.pumpWidget(const WorldRadioApp());
    final controller = PlayerScope.of(tester.element(find.byType(HomeScreen)));

    controller.setSleepTimer('Soon', const Duration(milliseconds: 10));
    expect(controller.sleepTimer, 'Soon');
    await tester.pump(const Duration(milliseconds: 20));
    expect(controller.sleepTimer, 'Off');
    expect(tester.takeException(), isNull);
  });
}

const _invalidStation = RadioStation(
  stationUuid: 'invalid-test-station',
  name: 'BBC Radio 1',
  url: '',
  urlResolved: '',
  homepage: '',
  favicon: '',
  tags: ['Pop'],
  country: 'United Kingdom',
  countryCode: 'GB',
  state: 'London',
  language: 'English',
  languageCodes: ['eng'],
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
