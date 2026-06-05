import 'package:dinner_sticks/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('US4: Adjust the Bin After Selection', () {
    testWidgets(
      'replace random, remove; verify pool unaffected',
      (tester) async {
        await tester.pumpWidget(const ProviderScope(child: App()));
        await tester.pumpAndSettle();

        // Add 6 sticks and select a week (5 in bin, 1 spare for replacement)
        await tester.tap(find.byTooltip('Manage meal ideas'));
        await tester.pumpAndSettle();

        for (final name in [
          'Pasta', 'Pizza', 'Tacos', 'Sushi', 'Curry', 'Salad',
        ]) {
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

        // Long-press first bin stick to get action sheet
        final tiles = find.byType(ListTile);
        await tester.longPress(tiles.first);
        await tester.pumpAndSettle();

        // Replace with random
        await tester.tap(find.text('Replace'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Random'));
        await tester.pumpAndSettle();

        // Still 5 sticks in bin (replaced, not removed)
        expect(find.byType(ListTile), findsNWidgets(5));

        // Long-press another bin stick → Remove
        await tester.longPress(find.byType(ListTile).first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Remove'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        // 4 sticks in bin
        expect(find.byType(ListTile), findsNWidgets(4));

        // Pool still has all 6 sticks
        await tester.tap(find.byTooltip('Manage meal ideas'));
        await tester.pumpAndSettle();
        expect(find.byType(ListTile), findsNWidgets(6));
      },
    );
  });
}
