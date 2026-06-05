import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:dinner_sticks/domain/failures.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';
import 'package:dinner_sticks/domain/usecases/bin/replace_bin_stick.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'replace_bin_stick_test.mocks.dart';

@GenerateMocks([PoolRepository])
void main() {
  late MockPoolRepository mockRepo;
  late ReplaceBinStick useCase;

  final createdAt = DateTime(2024);

  final bin = WeeklyBin(
    poolId: 'pool-1',
    stickIds: const ['s1', 's2'],
    doneStickIds: const [],
    createdAt: createdAt,
    updatedAt: createdAt,
  );

  final stickS3 = Stick(
    externalId: 's3',
    poolId: 'pool-1',
    name: 'Pizza',
    createdAt: createdAt,
  );

  final updatedBin = WeeklyBin(
    poolId: 'pool-1',
    stickIds: const ['s3', 's2'],
    doneStickIds: const [],
    createdAt: createdAt,
    updatedAt: createdAt,
  );

  setUp(() {
    mockRepo = MockPoolRepository();
    useCase = ReplaceBinStick(repository: mockRepo);
  });

  test('pick mode: places specified newStickId in bin', () async {
    when(mockRepo.getWeeklyBin('pool-1')).thenAnswer((_) async => bin);
    when(mockRepo.replaceBinStick('pool-1', 's1', 's3'))
        .thenAnswer((_) async => updatedBin);

    final result = await useCase(
      poolId: 'pool-1',
      oldStickId: 's1',
      newStickId: 's3',
    );

    expect(result, updatedBin);
    verify(mockRepo.replaceBinStick('pool-1', 's1', 's3')).called(1);
  });

  test('random mode: picks from pool sticks not already in bin', () async {
    when(mockRepo.getWeeklyBin('pool-1')).thenAnswer((_) async => bin);
    when(mockRepo.watchSticks('pool-1'))
        .thenAnswer((_) => Stream.value([stickS3]));
    when(mockRepo.replaceBinStick('pool-1', 's1', 's3'))
        .thenAnswer((_) async => updatedBin);

    final result = await useCase(poolId: 'pool-1', oldStickId: 's1');

    expect(result, updatedBin);
    verify(mockRepo.replaceBinStick('pool-1', 's1', 's3')).called(1);
  });

  test(
      'random mode: throws NoReplacementAvailableFailure '
      'when all pool sticks in bin',
      () async {
    when(mockRepo.getWeeklyBin('pool-1')).thenAnswer((_) async => bin);
    when(mockRepo.watchSticks('pool-1')).thenAnswer(
      (_) => Stream.value([
        Stick(
          externalId: 's1',
          poolId: 'pool-1',
          name: 'A',
          createdAt: createdAt,
        ),
        Stick(
          externalId: 's2',
          poolId: 'pool-1',
          name: 'B',
          createdAt: createdAt,
        ),
      ]),
    );

    await expectLater(
      useCase(poolId: 'pool-1', oldStickId: 's1'),
      throwsA(isA<NoReplacementAvailableFailure>()),
    );
  });

  test(
      'pick mode: throws NoReplacementAvailableFailure '
      'when newStickId already in bin',
      () async {
    when(mockRepo.getWeeklyBin('pool-1')).thenAnswer((_) async => bin);

    await expectLater(
      useCase(poolId: 'pool-1', oldStickId: 's1', newStickId: 's2'),
      throwsA(isA<NoReplacementAvailableFailure>()),
    );
  });
}
