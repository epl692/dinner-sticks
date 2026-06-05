import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:dinner_sticks/domain/failures.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';

/// Saves the drawn stick IDs as this week's bin for the active pool.
class ConfirmWeeklySelection {
  /// Creates a [ConfirmWeeklySelection] use-case.
  const ConfirmWeeklySelection({required this.repository});

  /// The repository used to persist the weekly bin.
  final PoolRepository repository;

  /// Saves [stickIds] as the weekly bin for [poolId].
  ///
  /// Throws InsufficientSticksFailure when [stickIds] is empty.
  Future<WeeklyBin> call({
    required String poolId,
    required List<String> stickIds,
  }) async {
    if (stickIds.isEmpty) throw const InsufficientSticksFailure();
    return repository.confirmSelection(poolId, stickIds);
  }
}
