import 'package:dinner_sticks/domain/entities/pool.dart';
import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/domain/usecases/stick/delete_stick.dart';
import 'package:dinner_sticks/gen_l10n/app_localizations.dart';
import 'package:dinner_sticks/presentation/providers/pool_providers.dart';
import 'package:dinner_sticks/presentation/widgets/stick_editor_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Screen for managing meal ideas (sticks) in the active pool.
class PoolManagementScreen extends ConsumerWidget {
  /// Creates a [PoolManagementScreen].
  const PoolManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poolAsync = ref.watch(activePoolProvider);

    return poolAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (pool) => _PoolManagementContent(pool: pool),
    );
  }
}

class _PoolManagementContent extends ConsumerWidget {
  const _PoolManagementContent({required this.pool});

  final Pool pool;

  Future<void> _openAddSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => StickEditorSheet(poolId: pool.externalId),
    );
  }

  Future<void> _openStickActions(
    BuildContext context,
    WidgetRef ref,
    Stick stick,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (_) => _StickActionsSheet(
        pool: pool,
        stick: stick,
        ref: ref,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sticksAsync = ref.watch(poolSticksProvider(pool.externalId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.mealIdeasTitle(pool.name)),
      ),
      body: sticksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (sticks) => sticks.isEmpty
            ? Center(child: Text(l10n.emptyPoolMessage))
            : ListView.builder(
                itemCount: sticks.length,
                itemBuilder: (ctx, i) {
                  final stick = sticks[i];
                  return Semantics(
                    label: '${stick.name}, meal idea',
                    button: true,
                    child: ListTile(
                      title: Text(stick.name),
                      onTap: () =>
                          _openStickActions(context, ref, stick),
                      minVerticalPadding: 12,
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addMealIdeaTooltip,
        onPressed: () => _openAddSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _StickActionsSheet extends StatelessWidget {
  const _StickActionsSheet({
    required this.pool,
    required this.stick,
    required this.ref,
  });

  final Pool pool;
  final Stick stick;
  final WidgetRef ref;

  Future<void> _edit(BuildContext context) async {
    Navigator.of(context).pop();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => StickEditorSheet(
        poolId: pool.externalId,
        stickId: stick.externalId,
        initialName: stick.name,
      ),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    Navigator.of(context).pop();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteMealIdeaTitle),
        content: Text(l10n.deleteMealIdeaMessage(stick.name)),
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
      await DeleteStick(repository: repo).call(stickId: stick.externalId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            stick.name,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: Text(l10n.editLabel),
          onTap: () => _edit(context),
          minVerticalPadding: 12,
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: Text(l10n.deleteLabel),
          onTap: () => _delete(context),
          minVerticalPadding: 12,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
