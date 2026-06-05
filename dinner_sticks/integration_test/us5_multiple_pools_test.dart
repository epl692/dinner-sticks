import 'package:dinner_sticks/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('US5: Manage Multiple Meal Pools', () {
    testWidgets(
      'create Breakfast pool; bins are independent; switch pools',
      (tester) async {
        await tester.pumpWidget(const ProviderScope(child: App()));
        await tester.pumpAndSettle();

        // Add 5 sticks to Dinner pool and select the week
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

        // Tap pool name chip to switch to PoolSwitcherScreen
        await tester.tap(find.text('Dinner'));
        await tester.pumpAndSettle();

        // Create Breakfast pool
        await tester.tap(find.byTooltip('Add pool'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Breakfast');
        await tester.tap(find.text('Create'));
        await tester.pumpAndSettle();

        // Now on HomeScreen for Breakfast pool — empty bin
        expect(find.text('No meals planned this week'), findsOneWidget);

        // Add 5 Breakfast sticks and select the week
        await tester.tap(find.byTooltip('Manage meal ideas'));
        await tester.pumpAndSettle();

        for (final name in ['Eggs', 'Oats', 'Pancakes', 'Waffles', 'Toast']) {
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

        // Breakfast bin has Breakfast sticks
        expect(find.text('Pasta'), findsNothing);

        // Switch back to Dinner pool
        await tester.tap(find.text('Breakfast'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Dinner'));
        await tester.pumpAndSettle();

        // Dinner bin still has Dinner sticks
        expect(find.text('Pasta'), findsOneWidget);
        expect(find.text('Eggs'), findsNothing);
      },
    );
  });
}
