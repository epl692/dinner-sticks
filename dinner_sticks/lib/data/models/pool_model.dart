import 'package:dinner_sticks/domain/entities/pool.dart';
import 'package:isar/isar.dart';

part 'pool_model.g.dart';

/// Isar-persisted representation of a [Pool].
@collection
class PoolModel {
  /// Default constructor required by Isar code generation.
  PoolModel();

  /// Creates a [PoolModel] from a domain [Pool].
  factory PoolModel.fromEntity(Pool pool) => PoolModel()
    ..externalId = pool.externalId
    ..name = pool.name
    ..createdAt = pool.createdAt;

  /// Isar auto-increment primary key.
  Id id = Isar.autoIncrement;

  /// UUID v4 — matches [Pool.externalId].
  late String externalId;

  /// Pool display name — unique case-insensitively across all pools.
  @Index(unique: true, caseSensitive: false)
  late String name;

  /// When this pool was created.
  late DateTime createdAt;

  /// Converts this model to a domain [Pool].
  Pool toEntity() => Pool(
        externalId: externalId,
        name: name,
        createdAt: createdAt,
      );
}
