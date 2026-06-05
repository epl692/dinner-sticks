import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// A list tile representing a stick in the weekly bin.
///
/// Supports tap-to-highlight, a Done button on the highlighted stick, and
/// a long-press action sheet for Replace/Remove.
class BinStickTile extends StatelessWidget {
  /// Creates a [BinStickTile].
  const BinStickTile({
    required this.stick,
    required this.isHighlighted,
    required this.onTap,
    required this.onDone,
    this.onLongPress,
    super.key,
  });

  /// The stick to display.
  final Stick stick;

  /// Whether this tile is the currently highlighted pick.
  final bool isHighlighted;

  /// Called when the tile is tapped.
  final VoidCallback onTap;

  /// Called when the Done button is tapped (only shown when highlighted).
  final VoidCallback onDone;

  /// Called on long-press; opens Replace/Remove action sheet.
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Semantics(
      label: stick.name,
      hint: isHighlighted ? l10n.stickSelectedHint : l10n.stickInPlanHint,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: ColoredBox(
          color: isHighlighted
              ? theme.colorScheme.primaryContainer
              : Colors.transparent,
          child: ListTile(
            title: Text(stick.name),
            trailing: isHighlighted
                ? Semantics(
                    label: l10n.markStickDoneLabel(stick.name),
                    button: true,
                    child: FilledButton(
                      onPressed: onDone,
                      child: Text(l10n.doneLabel),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
