import 'package:dinner_sticks/domain/entities/pool.dart';
import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:dinner_sticks/gen_l10n/app_localizations.dart';
import 'package:dinner_sticks/presentation/providers/bin_providers.dart';
import 'package:dinner_sticks/presentation/providers/pool_providers.dart';
import 'package:dinner_sticks/presentation/screens/home/home_screen.dart';
import 'package:dinner_sticks/presentation/widgets/bin_stick_tile.dart';
import 'package:dinner_sticks/presentation/widgets/empty_bin_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final pool = Pool(
    externalId: 'pool-1',
    name: 'Dinner',
    createdAt: DateTime(2024),
  );

  final createdAt = DateTime(2024);

  final stick1 = Stick(
    externalId: 's1',
    poolId: 'pool-1',
    name: 'Pasta',
    createdAt: createdAt,
  );
  final stick2 = Stick(
    externalId: 's2',
    poolId: 'pool-1',
    name: 'Pizza',
    createdAt: createdAt,
  );

  final bin = WeeklyBin(
    poolId: 'pool-1',
    stickIds: const ['s1', 's2'],
    doneStickIds: const [],
    createdAt: createdAt,
    updatedAt: createdAt,
  );

  Widget buildHomeScreen({
    List<Stick> binSticks = const [],
    WeeklyBin? weeklyBin,
  }) {
    return ProviderScope(
      overrides: [
        activePoolProvider.overrideWith((_) => AsyncValue.data(pool)),
        weeklyBinProvider('pool-1')
            .overrideWith((_) => Stream.value(weeklyBin)),
        binSticksProvider('pool-1')
            .overrideWith((_) => AsyncValue.data(binSticks)),
      ],
      // ignore: prefer_const_constructors
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeScreen(),
      ),
    );
  }

  testWidgets('shows BinStickTile for each bin stick', (tester) async {
    await tester.pumpWidget(
      buildHomeScreen(binSticks: [stick1, stick2], weeklyBin: bin),
    );
    await tester.pumpAndSettle();

    expect(find.byType(BinStickTile), findsNWidgets(2));
    expect(find.text('Pasta'), findsOneWidget);
    expect(find.text('Pizza'), findsOneWidget);
  });

  testWidgets('shows EmptyBinPrompt when bin is null', (tester) async {
    await tester.pumpWidget(buildHomeScreen());
    await tester.pumpAndSettle();

    expect(find.byType(EmptyBinPrompt), findsOneWidget);
    expect(find.text('No meals planned this week'), findsOneWidget);
  });

  testWidgets('shows EmptyBinPrompt when bin has no active sticks',
      (tester) async {
    await tester.pumpWidget(
      buildHomeScreen(weeklyBin: bin),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptyBinPrompt), findsOneWidget);
  });

  testWidgets(
      'shows random pick button with correct accessibility label',
      (tester) async {
    await tester.pumpWidget(
      buildHomeScreen(binSticks: [stick1, stick2], weeklyBin: bin),
    );
    await tester.pumpAndSettle();

    expect(
      find.byTooltip("Pick a random meal from this week's plan"),
      findsOneWidget,
    );
  });
}
