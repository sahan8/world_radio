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
}
