import 'package:dinner_sticks/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("US2: Select This Week's Sticks", () {
    testWidgets(
      'pool of 7: draw 5, discard 2, confirm; bin has 5 non-discarded sticks',
      (tester) async {
        await tester.pumpWidget(const ProviderScope(child: App()));
        await tester.pumpAndSettle();

        // Navigate to Pool Management and add 7 sticks
        await tester.tap(find.byTooltip('Manage meal ideas'));
        await tester.pumpAndSettle();

        final stickNames = [
          'Pasta', 'Pizza', 'Tacos', 'Sushi',
          'Curry', 'Burger', 'Salad',
        ];
        for (final name in stickNames) {
          await tester.tap(find.byTooltip('Add meal idea'));
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(TextField), name);
          await tester.tap(find.text('Save'));
          await tester.pumpAndSettle();
        }

        // Navigate back to Home, then to WeeklySelectionScreen
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip("Select this week's meals"));
        await tester.pumpAndSettle();

        // 5 sticks should be auto-drawn
        expect(find.byType(ListTile), findsNWidgets(5));

        // Discard first two drawn sticks
        final discardButtons = find.byTooltip('Discard');
        await tester.tap(discardButtons.first);
        await tester.pumpAndSettle();
        await tester.tap(discardButtons.first);
        await tester.pumpAndSettle();

        // Still 5 drawn (auto-replaced)
        expect(find.byType(ListTile), findsNWidgets(5));

        // Confirm
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        // Back on Home; bin should show 5 sticks
        expect(find.byType(ListTile), findsNWidgets(5));
      },
    );
  });
}
