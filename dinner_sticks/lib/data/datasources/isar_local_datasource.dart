import 'package:dinner_sticks/data/models/pool_model.dart';
import 'package:dinner_sticks/data/models/stick_model.dart';
import 'package:dinner_sticks/data/models/weekly_bin_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Manages the local Isar database connection and first-launch seeding.
class IsarLocalDataSource {
  IsarLocalDataSource._(this.isar);

  /// Opens (or re-opens) the Isar database and seeds the default "Dinner" pool
  /// if no pools exist yet.
  static Future<IsarLocalDataSource> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      [PoolModelSchema, StickModelSchema, WeeklyBinModelSchema],
      directory: dir.path,
    );
    await _seedIfEmpty(isar);
    return IsarLocalDataSource._(isar);
  }

  /// The Isar database instance.
  final Isar isar;

  static Future<void> _seedIfEmpty(Isar isar) async {
    final poolCount = await isar.poolModels.count();
    if (poolCount == 0) {
      await isar.writeTxn(() async {
        await isar.poolModels.put(
          PoolModel()
            ..externalId = const Uuid().v4()
            ..name = 'Dinner'
            ..createdAt = DateTime.now(),
        );
      });
    }
  }
}
