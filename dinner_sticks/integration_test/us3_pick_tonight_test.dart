import 'package:dinner_sticks/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group("US3: Pick Tonight's Meal from the Bin", () {
    testWidgets(
      'pre-populated bin: random pick, manual pick, mark done, all-done state',
      (tester) async {
        await tester.pumpWidget(const ProviderScope(child: App()));
        await tester.pumpAndSettle();

        // Set up pool with 5 sticks and select the week
        await tester.tap(find.byTooltip('Manage meal ideas'));
        await tester.pumpAndSettle();

        for (final name in ['Pasta', 'Pizza', 'Tacos', 'Sushi', 'Curry']) {
          await tester.tap(find.byTooltip('Add meal idea'));
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(TextField), name);
          await tester.tap(find.text('Save'));
          await tester.pumpAndSettle();
        }

        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        await tester.tap(find.byTooltip("Select this week's meals"));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        // Home screen shows 5 bin sticks
        expect(find.byType(ListTile), findsNWidgets(5));

        // Tap random pick FAB
        await tester.tap(
          find.byTooltip("Pick a random meal from this week's plan"),
        );
        await tester.pumpAndSettle();

        // A stick should be highlighted with a Done button
        expect(find.text('Done'), findsOneWidget);

        // Tap Done to mark it done
        await tester.tap(find.text('Done'));
        await tester.pumpAndSettle();

        // 4 sticks remain
        expect(find.byType(ListTile), findsNWidgets(4));

        // Tap first stick manually
        final tiles = find.byType(ListTile);
        await tester.tap(tiles.first);
        await tester.pumpAndSettle();
        expect(find.text('Done'), findsOneWidget);

        // Mark all remaining done
        for (var i = 0; i < 4; i++) {
          final doneBtn = find.text('Done');
          if (doneBtn.evaluate().isEmpty) break;
          await tester.tap(find.byType(ListTile).first);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Done'));
          await tester.pumpAndSettle();
        }

        // Empty bin state shown
        expect(find.text('No meals planned this week'), findsOneWidget);
      },
    );
  });
}
