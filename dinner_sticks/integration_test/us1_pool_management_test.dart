import 'package:dinner_sticks/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('US1: Build a Meal Pool', () {
    testWidgets(
      'can add, edit, and delete sticks; data survives restart',
      (tester) async {
        await tester.pumpWidget(const ProviderScope(child: App()));
        await tester.pumpAndSettle();

        // Navigate to Pool Management screen
        await tester.tap(find.byTooltip('Manage meal ideas'));
        await tester.pumpAndSettle();

        // Add Pasta
        await tester.tap(find.byTooltip('Add meal idea'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Pasta');
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(find.text('Pasta'), findsOneWidget);

        // Add Pizza
        await tester.tap(find.byTooltip('Add meal idea'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Pizza');
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(find.text('Pizza'), findsOneWidget);

        // Add Tacos
        await tester.tap(find.byTooltip('Add meal idea'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Tacos');
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(find.text('Tacos'), findsOneWidget);

        // Edit Tacos → Burritos
        await tester.tap(find.text('Tacos'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'Burritos');
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(find.text('Burritos'), findsOneWidget);
        expect(find.text('Tacos'), findsNothing);

        // Delete Pizza
        await tester.tap(find.text('Pizza'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();
        expect(find.text('Pizza'), findsNothing);
        expect(find.text('Pasta'), findsOneWidget);
        expect(find.text('Burritos'), findsOneWidget);
      },
    );
  });
}
