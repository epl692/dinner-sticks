import 'package:dinner_sticks/gen_l10n/app_localizations.dart';
import 'package:dinner_sticks/presentation/screens/weekly_selection/weekly_selection_screen.dart';
import 'package:flutter/material.dart';

/// Shown on the home screen when the bin is null or all sticks are done.
///
/// Provides a CTA that navigates to WeeklySelectionScreen.
class EmptyBinPrompt extends StatelessWidget {
  /// Creates an [EmptyBinPrompt].
  const EmptyBinPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.emptyBinMessage,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const WeeklySelectionScreen(),
              ),
            ),
            child: Text(l10n.selectWeekMealsButton),
          ),
        ],
      ),
    );
  }
}
