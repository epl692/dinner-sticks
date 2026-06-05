import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:isar/isar.dart';

part 'stick_model.g.dart';

/// Isar-persisted representation of a [Stick].
@collection
class StickModel {
  /// Default constructor required by Isar code generation.
  StickModel();

  /// Creates a [StickModel] from a domain [Stick].
  factory StickModel.fromEntity(Stick stick) => StickModel()
    ..externalId = stick.externalId
    ..poolId = stick.poolId
    ..name = stick.name
    ..createdAt = stick.createdAt;

  /// Isar auto-increment primary key.
  Id id = Isar.autoIncrement;

  /// UUID v4 — matches [Stick.externalId].
  late String externalId;

  /// The pool this stick belongs to (Pool.externalId).
  ///
  /// Composite unique index with [name]: a name must be unique within a pool
  /// (case-insensitive).
  // Composite unique index (poolId, name): name is unique within a pool
  // (case-insensitive comparison).
  @Index(
    composite: [CompositeIndex('name', caseSensitive: false)],
    unique: true,
  )
  late String poolId;

  /// Stick display name.
  late String name;

  /// When this stick was created.
  late DateTime createdAt;

  /// Converts this model to a domain [Stick].
  Stick toEntity() => Stick(
        externalId: externalId,
        poolId: poolId,
        name: name,
        createdAt: createdAt,
      );
}
