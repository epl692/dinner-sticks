import 'package:meta/meta.dart';

/// A named collection of meal ideas (sticks).
@immutable
class Pool {
  /// Creates a [Pool].
  const Pool({
    required this.externalId,
    required this.name,
    required this.createdAt,
  });

  /// Unique identifier (UUID v4). Immutable after creation.
  final String externalId;

  /// Display name. Unique case-insensitively across all pools.
  final String name;

  /// When this pool was created.
  final DateTime createdAt;

  /// Returns a copy with the given fields replaced.
  Pool copyWith({
    String? externalId,
    String? name,
    DateTime? createdAt,
  }) {
    return Pool(
      externalId: externalId ?? this.externalId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pool && other.externalId == externalId;
  }

  @override
  int get hashCode => externalId.hashCode;

  @override
  String toString() => 'Pool(externalId: $externalId, name: $name)';
}
