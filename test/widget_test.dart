import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:world_radio/app.dart';

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
    expect(find.text('BBC Radio 1'), findsWidgets);
    expect(find.text('Search stations, countries, genres...'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1600));
    await tester.pumpAndSettle();

    expect(find.text('RECENTLY PLAYED'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
