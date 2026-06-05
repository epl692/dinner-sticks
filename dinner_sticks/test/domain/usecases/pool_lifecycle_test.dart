import 'package:dinner_sticks/domain/entities/pool.dart';
import 'package:dinner_sticks/domain/failures.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';
import 'package:dinner_sticks/domain/usecases/pool/delete_pool.dart';
import 'package:dinner_sticks/domain/usecases/pool/rename_pool.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'pool_lifecycle_test.mocks.dart';

@GenerateMocks([PoolRepository])
void main() {
  late MockPoolRepository mockRepo;

  setUp(() {
    mockRepo = MockPoolRepository();
  });

  group('RenamePool', () {
    late RenamePool useCase;

    final renamedPool = Pool(
      externalId: 'pool-1',
      name: 'Lunch',
      createdAt: DateTime(2024),
    );

    setUp(() => useCase = RenamePool(repository: mockRepo));

    test('calls repository with trimmed newName', () async {
      when(mockRepo.renamePool('pool-1', 'Lunch'))
          .thenAnswer((_) async => renamedPool);

      final result = await useCase(poolId: 'pool-1', newName: '  Lunch  ');

      expect(result, renamedPool);
      verify(mockRepo.renamePool('pool-1', 'Lunch')).called(1);
    });

    test('throws ArgumentError for empty newName', () async {
      await expectLater(
        useCase(poolId: 'pool-1', newName: ''),
        throwsA(isA<ArgumentError>()),
      );
      verifyZeroInteractions(mockRepo);
    });

    test('propagates DuplicateNameFailure from repository', () async {
      when(mockRepo.renamePool('pool-1', 'Dinner'))
          .thenThrow(const DuplicateNameFailure('Dinner'));

      await expectLater(
        useCase(poolId: 'pool-1', newName: 'Dinner'),
        throwsA(isA<DuplicateNameFailure>()),
      );
    });

    test('propagates PoolNotFoundFailure from repository', () async {
      when(mockRepo.renamePool('nonexistent', 'Lunch'))
          .thenThrow(const PoolNotFoundFailure('nonexistent'));

      await expectLater(
        useCase(poolId: 'nonexistent', newName: 'Lunch'),
        throwsA(isA<PoolNotFoundFailure>()),
      );
    });
  });

  group('DeletePool', () {
    late DeletePool useCase;

    setUp(() => useCase = DeletePool(repository: mockRepo));

    test('delegates to repository.deletePool', () async {
      when(mockRepo.deletePool('pool-1')).thenAnswer((_) async {});

      await useCase(poolId: 'pool-1');

      verify(mockRepo.deletePool('pool-1')).called(1);
    });

    test('propagates PoolNotFoundFailure from repository', () async {
      when(mockRepo.deletePool('nonexistent'))
          .thenThrow(const PoolNotFoundFailure('nonexistent'));

      await expectLater(
        useCase(poolId: 'nonexistent'),
        throwsA(isA<PoolNotFoundFailure>()),
      );
    });
  });
}
