import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/domain/failures.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';
import 'package:dinner_sticks/domain/usecases/stick/add_stick.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_stick_test.mocks.dart';

@GenerateMocks([PoolRepository])
void main() {
  late MockPoolRepository mockRepo;
  late AddStick useCase;

  final createdAt = DateTime(2024);

  setUp(() {
    mockRepo = MockPoolRepository();
    useCase = AddStick(repository: mockRepo);
  });

  test('calls repository with trimmed name', () async {
    final expected = Stick(
      externalId: 'stick-1',
      poolId: 'pool-1',
      name: 'Pasta',
      createdAt: createdAt,
    );
    when(mockRepo.addStick('pool-1', 'Pasta'))
        .thenAnswer((_) async => expected);

    final result = await useCase(poolId: 'pool-1', name: '  Pasta  ');

    expect(result, expected);
    verify(mockRepo.addStick('pool-1', 'Pasta')).called(1);
  });

  test('throws ArgumentError for empty name', () async {
    await expectLater(
      useCase(poolId: 'pool-1', name: ''),
      throwsA(isA<ArgumentError>()),
    );
    verifyZeroInteractions(mockRepo);
  });

  test('throws ArgumentError for whitespace-only name', () async {
    await expectLater(
      useCase(poolId: 'pool-1', name: '   '),
      throwsA(isA<ArgumentError>()),
    );
    verifyZeroInteractions(mockRepo);
  });

  test('propagates DuplicateNameFailure from repository', () async {
    when(mockRepo.addStick('pool-1', 'Pasta'))
        .thenThrow(const DuplicateNameFailure('Pasta'));

    await expectLater(
      useCase(poolId: 'pool-1', name: 'Pasta'),
      throwsA(isA<DuplicateNameFailure>()),
    );
  });
}
