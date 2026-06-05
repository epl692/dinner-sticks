import 'dart:math';

import 'package:dinner_sticks/domain/entities/pool.dart';
import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/domain/usecases/bin/mark_stick_done.dart';
import 'package:dinner_sticks/domain/usecases/bin/remove_bin_stick.dart';
import 'package:dinner_sticks/domain/usecases/bin/replace_bin_stick.dart';
import 'package:dinner_sticks/gen_l10n/app_localizations.dart';
import 'package:dinner_sticks/presentation/providers/bin_providers.dart';
import 'package:dinner_sticks/presentation/providers/pool_providers.dart';
import 'package:dinner_sticks/presentation/screens/pool_management/pool_management_screen.dart';
import 'package:dinner_sticks/presentation/screens/pool_switcher/pool_switcher_screen.dart';
import 'package:dinner_sticks/presentation/screens/weekly_selection/weekly_selection_screen.dart';
import 'package:dinner_sticks/presentation/widgets/bin_stick_tile.dart';
import 'package:dinner_sticks/presentation/widgets/empty_bin_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Primary home screen showing this week's bin.
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _highlightedStickId;

  @override
  Widget build(BuildContext context) {
    final poolAsync = ref.watch(activePoolProvider);

    return poolAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: _buildForPool,
    );
  }

  Widget _buildForPool(Pool pool) {
    final l10n = AppLocalizations.of(context)!;
    final binSticksAsync = ref.watch(binSticksProvider(pool.externalId));
    final hasSticks =
        binSticksAsync.valueOrNull?.isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: l10n.activePoolLabel(pool.name),
          button: true,
          child: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const PoolSwitcherScreen(),
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            child: Text(pool.name),
          ),
        ),
        actions: [
          if (hasSticks)
            IconButton(
              tooltip: l10n.startNewWeekTooltip,
              icon: const Icon(Icons.calendar_month_outlined),
              onPressed: () => _navigateToSelection(context),
            ),
          Semantics(
            button: true,
            label: l10n.manageMealIdeasTooltip,
            child: IconButton(
              tooltip: l10n.manageMealIdeasTooltip,
              icon: const Icon(Icons.list_alt),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const PoolManagementScreen(),
                ),
              ),
            ),
          ),
        ],
      ),
      body: binSticksAsync.when(
        data: (sticks) => sticks.isEmpty
            ? const EmptyBinPrompt()
            : _buildBinList(sticks, pool),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: hasSticks
          ? Semantics(
              label: l10n.randomPickTooltip,
              button: true,
              child: FloatingActionButton(
                tooltip: l10n.randomPickTooltip,
                onPressed: () {
                  final sticks =
                      binSticksAsync.valueOrNull ?? <Stick>[];
                  _pickRandom(sticks);
                },
                child: const Icon(Icons.shuffle),
              ),
            )
          : null,
    );
  }

  Widget _buildBinList(List<Stick> sticks, Pool pool) {
    return ListView.builder(
      itemCount: sticks.length,
      itemBuilder: (context, index) {
        final stick = sticks[index];
        return BinStickTile(
          stick: stick,
          isHighlighted: _highlightedStickId == stick.externalId,
          onTap: () =>
              setState(() => _highlightedStickId = stick.externalId),
          onDone: () => _markDone(stick, pool),
          onLongPress: () => _showBinStickActions(context, stick, pool),
        );
      },
    );
  }

  void _pickRandom(List<Stick> sticks) {
    if (sticks.isEmpty) return;
    final pick = sticks[Random().nextInt(sticks.length)];
    setState(() => _highlightedStickId = pick.externalId);
  }

  Future<void> _markDone(Stick stick, Pool pool) async {
    final repo = await ref.read(poolRepositoryProvider.future);
    await MarkStickDone(repository: repo)
        .call(poolId: pool.externalId, stickId: stick.externalId);
    if (mounted) {
      setState(() {
        if (_highlightedStickId == stick.externalId) {
          _highlightedStickId = null;
        }
      });
    }
  }

  Future<void> _showBinStickActions(
    BuildContext context,
    Stick stick,
    Pool pool,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(l10n.replaceLabel),
              onTap: () {
                Navigator.of(ctx).pop();
                _showReplaceOptions(context, stick, pool);
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: Text(l10n.removeLabel),
              onTap: () {
                Navigator.of(ctx).pop();
                _confirmRemove(context, stick, pool);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel_outlined),
              title: Text(l10n.cancelLabel),
              onTap: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showReplaceOptions(
    BuildContext context,
    Stick stick,
    Pool pool,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.shuffle),
              title: Text(l10n.randomLabel),
              onTap: () {
                Navigator.of(ctx).pop();
                _replaceRandom(stick, pool);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: Text(l10n.pickOneLabel),
              onTap: () {
                Navigator.of(ctx).pop();
                _showPickOneSheet(context, stick, pool);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _replaceRandom(Stick stick, Pool pool) async {
    final repo = await ref.read(poolRepositoryProvider.future);
    await ReplaceBinStick(repository: repo).call(
      poolId: pool.externalId,
      oldStickId: stick.externalId,
    );
  }

  Future<void> _showPickOneSheet(
    BuildContext context,
    Stick oldStick,
    Pool pool,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final allSticks =
        await ref.read(poolSticksProvider(pool.externalId).future);
    final binAsync = ref.read(weeklyBinProvider(pool.externalId));
    final binStickIds = binAsync.valueOrNull?.stickIds ?? [];
    final available = allSticks
        .where((s) => !binStickIds.contains(s.externalId))
        .toList();

    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: available.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: Text(l10n.noOtherMealsAvailable),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: available.length,
                itemBuilder: (_, index) {
                  final candidate = available[index];
                  return ListTile(
                    title: Text(candidate.name),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _replacePick(oldStick, candidate, pool);
                    },
                  );
                },
              ),
      ),
    );
  }

  Future<void> _replacePick(Stick oldStick, Stick newStick, Pool pool) async {
    final repo = await ref.read(poolRepositoryProvider.future);
    await ReplaceBinStick(repository: repo).call(
      poolId: pool.externalId,
      oldStickId: oldStick.externalId,
      newStickId: newStick.externalId,
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    Stick stick,
    Pool pool,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.removeFromWeekTitle),
        content: Text(l10n.removeStickMessage(stick.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancelLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.confirmLabel),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      final repo = await ref.read(poolRepositoryProvider.future);
      await RemoveBinStick(repository: repo)
          .call(poolId: pool.externalId, stickId: stick.externalId);
      if (mounted && _highlightedStickId == stick.externalId) {
        setState(() => _highlightedStickId = null);
      }
    }
  }

  void _navigateToSelection(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const WeeklySelectionScreen(),
      ),
    );
  }
}
