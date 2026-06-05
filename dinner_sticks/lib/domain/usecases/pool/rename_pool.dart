import 'package:dinner_sticks/domain/entities/pool.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';

/// Renames an existing meal pool.
class RenamePool {
  /// Creates a [RenamePool] use-case.
  const RenamePool({required this.repository});

  /// The repository used to persist the rename.
  final PoolRepository repository;

  /// Renames the pool identified by [poolId] to [newName].
  ///
  /// Throws ArgumentError when [newName] is empty or whitespace.
  Future<Pool> call({
    required String poolId,
    required String newName,
  }) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(newName, 'newName', 'must not be empty');
    }
    return repository.renamePool(poolId, trimmed);
  }
}
