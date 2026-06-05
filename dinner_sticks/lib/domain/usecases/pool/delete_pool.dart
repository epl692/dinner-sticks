import 'package:dinner_sticks/domain/repositories/pool_repository.dart';

/// Deletes a meal pool and all its sticks.
///
/// If this is the last pool, the repository auto-creates a new empty "Dinner"
/// pool within the same transaction.
class DeletePool {
  /// Creates a [DeletePool] use-case.
  const DeletePool({required this.repository});

  /// The repository used to delete the pool.
  final PoolRepository repository;

  /// Deletes the pool identified by [poolId].
  Future<void> call({required String poolId}) async =>
      repository.deletePool(poolId);
}
