import 'package:meta/meta.dart';

/// A single meal idea belonging to one Pool.
@immutable
class Stick {
  /// Creates a [Stick].
  const Stick({
    required this.externalId,
    required this.poolId,
    required this.name,
    required this.createdAt,
  });

  /// Unique identifier (UUID v4). Immutable after creation.
  final String externalId;

  /// The externalId of the Pool this stick belongs to.
  final String poolId;

  /// Display name. Unique case-insensitively within the same pool.
  final String name;

  /// When this stick was created.
  final DateTime createdAt;

  /// Returns a copy with the given fields replaced.
  Stick copyWith({
    String? externalId,
    String? poolId,
    String? name,
    DateTime? createdAt,
  }) {
    return Stick(
      externalId: externalId ?? this.externalId,
      poolId: poolId ?? this.poolId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Stick && other.externalId == externalId;
  }

  @override
  int get hashCode => externalId.hashCode;

  @override
  String toString() =>
      'Stick(externalId: $externalId, poolId: $poolId, name: $name)';
}
