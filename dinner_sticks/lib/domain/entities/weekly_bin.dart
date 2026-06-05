import 'package:meta/meta.dart';

/// The set of sticks selected for the current week within a pool.
///
/// There is at most one active [WeeklyBin] per pool at any given time.
@immutable
class WeeklyBin {
  /// Creates a [WeeklyBin].
  const WeeklyBin({
    required this.poolId,
    required this.stickIds,
    required this.doneStickIds,
    required this.createdAt,
    required this.updatedAt,
  });

  /// The externalId of the Pool this bin belongs to.
  final String poolId;

  /// Ordered list of Stick.externalId values in this week's plan.
  ///
  /// May contain stale references if a stick was deleted after selection.
  final List<String> stickIds;

  /// Subset of [stickIds] that have been marked done.
  final List<String> doneStickIds;

  /// When this bin was confirmed.
  final DateTime createdAt;

  /// When this bin was last modified.
  final DateTime updatedAt;

  /// Returns a copy with the given fields replaced.
  WeeklyBin copyWith({
    String? poolId,
    List<String>? stickIds,
    List<String>? doneStickIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WeeklyBin(
      poolId: poolId ?? this.poolId,
      stickIds: stickIds ?? this.stickIds,
      doneStickIds: doneStickIds ?? this.doneStickIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeeklyBin && other.poolId == poolId;
  }

  @override
  int get hashCode => poolId.hashCode;

  @override
  String toString() =>
      'WeeklyBin(poolId: $poolId, stickIds: $stickIds)';
}
