import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:dinner_sticks/domain/failures.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';
import 'package:dinner_sticks/domain/usecases/bin/confirm_weekly_selection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'confirm_weekly_selection_test.mocks.dart';

@GenerateMocks([PoolRepository])
void main() {
  late MockPoolRepository mockRepo;
  late ConfirmWeeklySelection useCase;

  final bin = WeeklyBin(
    poolId: 'pool-1',
    stickIds: const ['s1', 's2', 's3'],
    doneStickIds: const [],
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  setUp(() {
    mockRepo = MockPoolRepository();
    useCase = ConfirmWeeklySelection(repository: mockRepo);
  });

  test('saves bin with correct stickIds', () async {
    when(mockRepo.confirmSelection('pool-1', ['s1', 's2', 's3']))
        .thenAnswer((_) async => bin);

    final result =
        await useCase(poolId: 'pool-1', stickIds: ['s1', 's2', 's3']);

    expect(result, bin);
    verify(mockRepo.confirmSelection('pool-1', ['s1', 's2', 's3'])).called(1);
  });

  test('replaces existing bin when called again', () async {
    final replacedBin = WeeklyBin(
      poolId: 'pool-1',
      stickIds: const ['s4', 's5'],
      doneStickIds: const [],
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    );
    when(mockRepo.confirmSelection('pool-1', ['s4', 's5']))
        .thenAnswer((_) async => replacedBin);

    final result = await useCase(poolId: 'pool-1', stickIds: ['s4', 's5']);

    expect(result.stickIds, ['s4', 's5']);
  });

  test('throws InsufficientSticksFailure when stickIds is empty', () async {
    await expectLater(
      useCase(poolId: 'pool-1', stickIds: []),
      throwsA(isA<InsufficientSticksFailure>()),
    );
    verifyZeroInteractions(mockRepo);
  });
}
