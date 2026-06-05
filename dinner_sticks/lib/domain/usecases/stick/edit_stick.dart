import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';

/// Validates and delegates renaming an existing stick.
///
/// Trims the new name and throws ArgumentError if empty, then calls the
/// repository.
class EditStick {
  /// Creates an [EditStick] use-case.
  const EditStick({required this.repository});

  /// The repository used to update the stick.
  final PoolRepository repository;

  /// Renames the stick identified by [stickId] to [newName].
  ///
  /// Trims [newName] and throws ArgumentError if empty after trimming.
  /// Propagates DuplicateNameFailure or StickNotFoundFailure from the
  /// repository.
  Future<Stick> call({required String stickId, required String newName}) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(newName, 'newName', 'must not be empty');
    }
    return repository.editStick(stickId, trimmed);
  }
}
