/// Base class for all typed domain failures.
///
/// Thrown by use-cases and repository methods; caught by Riverpod providers
/// and surfaced via AsyncValue.error.
sealed class Failure implements Exception {
  /// Creates a [Failure].
  const Failure();
}

/// Thrown when a pool or stick name already exists (case-insensitive).
final class DuplicateNameFailure extends Failure {
  /// Creates a [DuplicateNameFailure] for the given [name].
  const DuplicateNameFailure(this.name);

  /// The name that caused the conflict.
  final String name;

  @override
  String toString() => 'DuplicateNameFailure: "$name" already exists';
}

/// Thrown when a requested pool cannot be found by its externalId.
final class PoolNotFoundFailure extends Failure {
  /// Creates a [PoolNotFoundFailure] for the given [poolId].
  const PoolNotFoundFailure(this.poolId);

  /// The pool externalId that was not found.
  final String poolId;

  @override
  String toString() => 'PoolNotFoundFailure: pool "$poolId" not found';
}

/// Thrown when a requested stick cannot be found by its externalId.
final class StickNotFoundFailure extends Failure {
  /// Creates a [StickNotFoundFailure] for the given [stickId].
  const StickNotFoundFailure(this.stickId);

  /// The stick externalId that was not found.
  final String stickId;

  @override
  String toString() => 'StickNotFoundFailure: stick "$stickId" not found';
}

/// Thrown when a pool has too few sticks to complete a selection.
final class InsufficientSticksFailure extends Failure {
  /// Creates an [InsufficientSticksFailure].
  const InsufficientSticksFailure();

  @override
  String toString() => 'InsufficientSticksFailure: not enough sticks in pool';
}

/// Thrown when no eligible replacement stick exists for a bin replacement.
final class NoReplacementAvailableFailure extends Failure {
  /// Creates a [NoReplacementAvailableFailure].
  const NoReplacementAvailableFailure();

  @override
  String toString() =>
      'NoReplacementAvailableFailure: all pool sticks are already in the bin';
}
