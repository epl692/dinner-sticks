import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';

/// Validates and delegates adding a new stick to a pool.
///
/// Trims the name and throws ArgumentError if it is empty, then calls the
/// repository.
class AddStick {
  /// Creates an [AddStick] use-case.
  const AddStick({required this.repository});

  /// The repository used to persist the new stick.
  final PoolRepository repository;

  /// Adds a stick named [name] to the pool identified by [poolId].
  ///
  /// Trims [name] and throws ArgumentError if empty after trimming.
  /// Propagates DuplicateNameFailure from the repository.
  Future<Stick> call({required String poolId, required String name}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be empty');
    }
    return repository.addStick(poolId, trimmed);
  }
}
