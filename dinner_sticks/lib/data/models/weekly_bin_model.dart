import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:isar/isar.dart';

part 'weekly_bin_model.g.dart';

/// Isar-persisted representation of a [WeeklyBin].
@collection
class WeeklyBinModel {
  /// Default constructor required by Isar code generation.
  WeeklyBinModel();

  /// Creates a [WeeklyBinModel] from a domain [WeeklyBin].
  factory WeeklyBinModel.fromEntity(WeeklyBin bin) => WeeklyBinModel()
    ..poolId = bin.poolId
    ..stickIds = List<String>.from(bin.stickIds)
    ..doneStickIds = List<String>.from(bin.doneStickIds)
    ..createdAt = bin.createdAt
    ..updatedAt = bin.updatedAt;

  /// Isar auto-increment primary key.
  Id id = Isar.autoIncrement;

  /// The pool this bin belongs to (Pool.externalId). One bin per pool.
  @Index(unique: true)
  late String poolId;

  /// Ordered list of Stick.externalId values for this week.
  late List<String> stickIds;

  /// Subset of [stickIds] that have been marked done.
  late List<String> doneStickIds;

  /// When this bin was confirmed.
  late DateTime createdAt;

  /// When this bin was last modified.
  late DateTime updatedAt;

  /// Converts this model to a domain [WeeklyBin].
  WeeklyBin toEntity() => WeeklyBin(
        poolId: poolId,
        stickIds: List<String>.from(stickIds),
        doneStickIds: List<String>.from(doneStickIds),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
