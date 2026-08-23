import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:world_radio/app.dart';
import 'package:world_radio/features/home/presentation/widgets/mini_player.dart';
import 'package:world_radio/features/home/presentation/home_screen.dart';
import 'package:world_radio/features/player/application/player_controller.dart';
import 'package:world_radio/features/search/data/placeholder_stations.dart';

void main() {
  testWidgets('all navigation destinations open', (tester) async {
    await tester.pumpWidget(const WorldRadioApp());
    expect(find.text('WORLD RADIO'), findsOneWidget);
    for (final destination in ['Explore', 'Favorites', 'Settings', 'Home']) {
      await tester.tap(find.text(destination));
      await tester.pump();
    }
    expect(find.text('WORLD RADIO'), findsOneWidget);
  });

  testWidgets('home sections scroll without layout errors', (tester) async {
    await tester.pumpWidget(const WorldRadioApp());

    expect(find.text('LIVE NOW'), findsOneWidget);
    expect(find.text('Search stations, countries, genres...'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1600));
    await tester.pumpAndSettle();

    expect(find.text('RECENTLY PLAYED'), findsOneWidget);
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
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();

    expect(find.text('Tune into anywhere.'), findsOneWidget);
    expect(find.text('TOKYO'), findsOneWidget);
    expect(find.text('SRI LANKA'), findsOneWidget);

    await tester.tap(find.text('Genres'));
    await tester.pumpAndSettle();
    expect(find.text('ELECTRONIC'), findsOneWidget);

    await tester.tap(find.text('Languages'));
    await tester.pumpAndSettle();
    expect(find.text('Japanese'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('invalid station exposes recoverable player error state', (
    tester,
  ) async {
    await tester.pumpWidget(const WorldRadioApp());
    PlayerScope.of(tester.element(find.byType(HomeScreen)))
        .select(placeholderStations.first);
    await tester.pumpAndSettle();
    expect(find.byType(MiniPlayer), findsOneWidget);
    expect(find.byTooltip('Retry BBC Radio 1'), findsOneWidget);

    final miniRect = tester.getRect(find.byKey(const Key('mini-player-open')));
    await tester.tapAt(Offset(miniRect.left + 100, miniRect.center.dy));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('NOW PLAYING'), findsOneWidget);
    expect(find.text('SIGNAL LOST'), findsOneWidget);
    expect(find.bySemanticsLabel('Retry station'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
