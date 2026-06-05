import 'dart:math';

import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:dinner_sticks/domain/failures.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';

/// Replaces a stick in the weekly bin with another from the pool.
///
/// When newStickId is null, picks a random eligible stick (random mode).
/// When newStickId is provided, uses that specific stick (pick mode).
class ReplaceBinStick {
  /// Creates a [ReplaceBinStick] use-case.
  const ReplaceBinStick({required this.repository});

  /// The repository used to fetch pool/bin state and persist updates.
  final PoolRepository repository;

  /// Replaces [oldStickId] in the bin for [poolId].
  ///
  /// Throws NoReplacementAvailableFailure when no eligible replacement exists.
  /// Throws StickNotFoundFailure when [oldStickId] is not in the bin.
  Future<WeeklyBin> call({
    required String poolId,
    required String oldStickId,
    String? newStickId,
  }) async {
    final bin = await repository.getWeeklyBin(poolId);
    if (bin == null || !bin.stickIds.contains(oldStickId)) {
      throw StickNotFoundFailure(oldStickId);
    }

    final String resolvedNewId;
    if (newStickId != null) {
      if (bin.stickIds.contains(newStickId)) {
        throw const NoReplacementAvailableFailure();
      }
      resolvedNewId = newStickId;
    } else {
      final poolSticks = await repository.watchSticks(poolId).first;
      final available = poolSticks
          .where((s) => !bin.stickIds.contains(s.externalId))
          .toList();
      if (available.isEmpty) throw const NoReplacementAvailableFailure();
      resolvedNewId =
          available[Random().nextInt(available.length)].externalId;
    }

    return repository.replaceBinStick(poolId, oldStickId, resolvedNewId);
  }
}
