import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';

/// Removes a stick from the weekly bin without deleting it from the pool.
class RemoveBinStick {
  /// Creates a [RemoveBinStick] use-case.
  const RemoveBinStick({required this.repository});

  /// The repository used to update the weekly bin.
  final PoolRepository repository;

  /// Removes [stickId] from the bin for [poolId].
  Future<WeeklyBin> call({
    required String poolId,
    required String stickId,
  }) async =>
      repository.removeBinStick(poolId, stickId);
}
