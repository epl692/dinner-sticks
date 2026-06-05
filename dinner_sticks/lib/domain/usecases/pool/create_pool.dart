import 'package:dinner_sticks/domain/entities/pool.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';

/// Creates a new named meal pool.
class CreatePool {
  /// Creates a [CreatePool] use-case.
  const CreatePool({required this.repository});

  /// The repository used to persist the new pool.
  final PoolRepository repository;

  /// Creates a pool with the given [name].
  ///
  /// Throws ArgumentError when [name] is empty or whitespace.
  Future<Pool> call({required String name}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be empty');
    }
    return repository.createPool(trimmed);
  }
}
