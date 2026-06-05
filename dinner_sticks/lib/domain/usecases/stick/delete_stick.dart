import 'package:dinner_sticks/domain/repositories/pool_repository.dart';

/// Delegates deleting a stick to the repository.
class DeleteStick {
  /// Creates a [DeleteStick] use-case.
  const DeleteStick({required this.repository});

  /// The repository used to delete the stick.
  final PoolRepository repository;

  /// Deletes the stick identified by [stickId].
  ///
  /// Propagates StickNotFoundFailure if the stick does not exist.
  Future<void> call({required String stickId}) async =>
      repository.deleteStick(stickId);
}
