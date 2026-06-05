import 'package:dinner_sticks/domain/usecases/pool/create_pool.dart';
import 'package:dinner_sticks/gen_l10n/app_localizations.dart';
import 'package:dinner_sticks/presentation/providers/pool_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lists all pools and allows switching the active pool.
///
/// Also provides a way to create a new pool.
class PoolSwitcherScreen extends ConsumerWidget {
  /// Creates a [PoolSwitcherScreen].
  const PoolSwitcherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final poolsAsync = ref.watch(allPoolsProvider);
    final activePoolAsync = ref.watch(activePoolProvider);
    final activeId = activePoolAsync.valueOrNull?.externalId;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.switchPoolTitle)),
      body: poolsAsync.when(
        data: (pools) => ListView.builder(
          itemCount: pools.length,
          itemBuilder: (context, index) {
            final pool = pools[index];
            final isActive = pool.externalId == activeId;
            return Semantics(
              label: isActive
                  ? l10n.activePoolLabel(pool.name)
                  : pool.name,
              button: true,
              child: ListTile(
                title: Text(pool.name),
                trailing: isActive ? const Icon(Icons.check) : null,
                selected: isActive,
                onTap: () {
                  ref.read(activePoolIdProvider.notifier).state =
                      pool.externalId;
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addPoolTooltip,
        onPressed: () => _showAddPoolSheet(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddPoolSheet(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    String? errorText;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.newPoolTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: l10n.poolNameHint,
                      errorText: errorText,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(l10n.cancelLabel),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () async {
                          try {
                            final repo = await ref
                                .read(poolRepositoryProvider.future);
                            final pool = await CreatePool(repository: repo)
                                .call(name: controller.text);
                            ref
                                .read(activePoolIdProvider.notifier)
                                .state = pool.externalId;
                            if (context.mounted) Navigator.of(context).pop();
                          } on Exception catch (e) {
                            setSheetState(
                              () => errorText = e.toString(),
                            );
                          }
                        },
                        child: Text(l10n.createLabel),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    controller.dispose();
  }
}
