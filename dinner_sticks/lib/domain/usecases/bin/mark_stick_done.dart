import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';

/// Marks a bin stick as done, removing it from the active list.
class MarkStickDone {
  /// Creates a [MarkStickDone] use-case.
  const MarkStickDone({required this.repository});

  /// The repository used to update the weekly bin.
  final PoolRepository repository;

  /// Marks [stickId] as done in the bin for [poolId].
  Future<WeeklyBin> call({
    required String poolId,
    required String stickId,
  }) async =>
      repository.markStickDone(poolId, stickId);
}
