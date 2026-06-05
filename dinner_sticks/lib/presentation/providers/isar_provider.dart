import 'package:dinner_sticks/data/datasources/isar_local_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

/// Async-opens the Isar database (with first-launch seeding) and provides
/// the [Isar] instance to all repository providers.
///
/// This provider is intentionally kept alive for the lifetime of the app.
final isarProvider = FutureProvider<Isar>((ref) async {
  final dataSource = await IsarLocalDataSource.open();
  return dataSource.isar;
});
