import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:dinner_sticks/presentation/providers/pool_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emits the current weekly bin for a pool ID, or null when no bin exists.
final weeklyBinProvider =
    StreamProvider.family<WeeklyBin?, String>((ref, poolId) async* {
  final repo = await ref.watch(poolRepositoryProvider.future);
  yield* repo.watchWeeklyBin(poolId);
});

/// Active (non-done) sticks in the bin for a pool ID.
///
/// Derives from weeklyBinProvider and poolSticksProvider, filtering out
/// stale stickId references and sticks that are already done.
final binSticksProvider =
    Provider.family<AsyncValue<List<Stick>>, String>((ref, poolId) {
  final binAsync = ref.watch(weeklyBinProvider(poolId));
  final sticksAsync = ref.watch(poolSticksProvider(poolId));

  return binAsync.whenData((bin) {
    if (bin == null) return <Stick>[];
    final stickMap = {
      for (final s in sticksAsync.valueOrNull ?? <Stick>[]) s.externalId: s,
    };
    return bin.stickIds
        .where(
          (id) =>
              stickMap.containsKey(id) && !bin.doneStickIds.contains(id),
        )
        .map((id) => stickMap[id]!)
        .toList();
  });
});
