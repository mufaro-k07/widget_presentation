import 'package:flutter_test/flutter_test.dart';

import 'package:hero_widget/main.dart';

void main() {
  testWidgets('Gallery shows the Hero Gallery title', (WidgetTester tester) async {
    await tester.pumpWidget(const HeroDemo());

    expect(find.text('Hero Gallery'), findsOneWidget);
  });
}