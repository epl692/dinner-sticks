import 'package:dinner_sticks/domain/entities/selection_session.dart';
import 'package:dinner_sticks/domain/usecases/bin/confirm_weekly_selection.dart';
import 'package:dinner_sticks/gen_l10n/app_localizations.dart';
import 'package:dinner_sticks/presentation/providers/bin_providers.dart';
import 'package:dinner_sticks/presentation/providers/pool_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Drives the weekly draw flow.
///
/// Auto-draws up to 5 sticks on enter. User can discard individual sticks
/// (each discard auto-draws a replacement when available) then confirm to
/// save the weekly bin.
class WeeklySelectionScreen extends ConsumerStatefulWidget {
  /// Creates a [WeeklySelectionScreen].
  const WeeklySelectionScreen({super.key});

  @override
  ConsumerState<WeeklySelectionScreen> createState() =>
      _WeeklySelectionScreenState();
}

class _WeeklySelectionScreenState
    extends ConsumerState<WeeklySelectionScreen> {
  SelectionSession? _session;
  Map<String, String> _stickNames = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initSession());
  }

  Future<void> _initSession() async {
    final l10n = AppLocalizations.of(context)!;
    final pool = ref.read(activePoolProvider).valueOrNull;
    if (pool == null) return;

    final sticks = await ref.read(poolSticksProvider(pool.externalId).future);

    if (sticks.isEmpty) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    final existingBin =
        ref.read(weeklyBinProvider(pool.externalId)).valueOrNull;
    if (existingBin != null && mounted) {
      final replace = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.replaceWeekMealsTitle),
          content: Text(l10n.replaceWeekMealsContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.keepCurrentLabel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.startOverLabel),
            ),
          ],
        ),
      );
      if (replace != true) {
        if (mounted) Navigator.of(context).pop();
        return;
      }
    }

    final session = SelectionSession(
      poolId: pool.externalId,
      availableStickIds: sticks.map((s) => s.externalId).toList(),
    );
    for (var i = 0; i < 5; i++) {
      if (session.drawNext() == null) break;
    }

    if (mounted) {
      setState(() {
        _session = session;
        _stickNames = {for (final s in sticks) s.externalId: s.name};
      });
    }
  }

  Future<void> _confirm() async {
    final session = _session;
    if (session == null || session.drawnStickIds.isEmpty) return;
    setState(() => _saving = true);

    try {
      final repo = await ref.read(poolRepositoryProvider.future);
      await ConfirmWeeklySelection(repository: repo).call(
        poolId: session.poolId,
        stickIds: session.drawnStickIds,
      );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _discard(String stickId) {
    setState(() {
      _session?.discard(stickId);
      _session?.drawNext();
    });
  }

  String _nameFor(String stickId) => _stickNames[stickId] ?? stickId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final session = _session;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.selectWeekMealsTitle),
        actions: [
          if (session != null && session.drawnStickIds.isNotEmpty)
            TextButton(
              onPressed: _saving ? null : _confirm,
              child: Text(l10n.confirmLabel),
            ),
        ],
      ),
      body: session == null
          ? const Center(child: CircularProgressIndicator())
          : _buildSessionBody(session, l10n),
    );
  }

  Widget _buildSessionBody(SelectionSession session, AppLocalizations l10n) {
    final stickCount = session.drawnStickIds.length;

    return Column(
      children: [
        if (stickCount < 5)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              l10n.limitedMealsMessage(stickCount),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: stickCount,
            itemBuilder: (context, index) {
              final stickId = session.drawnStickIds[index];
              final name = _nameFor(stickId);
              return ListTile(
                title: Text(name),
                trailing: Semantics(
                  label: l10n.discardStickLabel(name),
                  button: true,
                  child: IconButton(
                    tooltip: l10n.discardTooltip,
                    icon: const Icon(Icons.close),
                    onPressed: () => _discard(stickId),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
