import 'package:dinner_sticks/data/repositories/pool_repository_impl.dart';
import 'package:dinner_sticks/domain/entities/pool.dart';
import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';
import 'package:dinner_sticks/presentation/providers/isar_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the Isar-backed [PoolRepository].
///
/// Resolves once [isarProvider] completes.
final poolRepositoryProvider = FutureProvider<PoolRepository>((ref) async {
  final isar = await ref.watch(isarProvider.future);
  return PoolRepositoryImpl(isar);
});

/// Emits all pools whenever any pool is created, renamed, or deleted.
final allPoolsProvider = StreamProvider<List<Pool>>((ref) async* {
  final repo = await ref.watch(poolRepositoryProvider.future);
  yield* repo.watchAllPools();
});

/// The externalId of the currently active pool.
///
/// `null` means "use the first available pool" — typically the Dinner pool
/// on first launch.
final activePoolIdProvider = StateProvider<String?>((ref) => null);

/// The resolved active [Pool].
///
/// Falls back to the first pool when `activePoolIdProvider` is `null` or its
/// id no longer exists in the pool list.
final activePoolProvider = Provider<AsyncValue<Pool>>((ref) {
  final poolsAsync = ref.watch(allPoolsProvider);
  final activeId = ref.watch(activePoolIdProvider);

  return poolsAsync.whenData((pools) {
    if (pools.isEmpty) throw StateError('No pools available');
    if (activeId == null) return pools.first;
    return pools.firstWhere(
      (p) => p.externalId == activeId,
      orElse: () => pools.first,
    );
  });
});

/// Emits sticks for the given pool id, sorted alphabetically by name.
final poolSticksProvider =
    StreamProvider.family<List<Stick>, String>((ref, poolId) async* {
  final repo = await ref.watch(poolRepositoryProvider.future);
  yield* repo.watchSticks(poolId).map((sticks) {
    final sorted = List.of(sticks)
      ..sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  });
});
