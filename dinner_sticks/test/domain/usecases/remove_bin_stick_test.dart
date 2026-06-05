import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:dinner_sticks/domain/failures.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';
import 'package:dinner_sticks/domain/usecases/bin/remove_bin_stick.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remove_bin_stick_test.mocks.dart';

@GenerateMocks([PoolRepository])
void main() {
  late MockPoolRepository mockRepo;
  late RemoveBinStick useCase;

  final updatedBin = WeeklyBin(
    poolId: 'pool-1',
    stickIds: const ['s2'],
    doneStickIds: const [],
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  setUp(() {
    mockRepo = MockPoolRepository();
    useCase = RemoveBinStick(repository: mockRepo);
  });

  test('delegates to repository.removeBinStick', () async {
    when(mockRepo.removeBinStick('pool-1', 's1'))
        .thenAnswer((_) async => updatedBin);

    final result = await useCase(poolId: 'pool-1', stickId: 's1');

    expect(result, updatedBin);
    verify(mockRepo.removeBinStick('pool-1', 's1')).called(1);
  });

  test('propagates StickNotFoundFailure from repository', () async {
    when(mockRepo.removeBinStick('pool-1', 'unknown'))
        .thenThrow(const StickNotFoundFailure('unknown'));

    await expectLater(
      useCase(poolId: 'pool-1', stickId: 'unknown'),
      throwsA(isA<StickNotFoundFailure>()),
    );
  });
}
