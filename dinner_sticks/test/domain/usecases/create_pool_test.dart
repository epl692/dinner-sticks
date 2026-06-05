import 'package:dinner_sticks/domain/entities/pool.dart';
import 'package:dinner_sticks/domain/failures.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';
import 'package:dinner_sticks/domain/usecases/pool/create_pool.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_pool_test.mocks.dart';

@GenerateMocks([PoolRepository])
void main() {
  late MockPoolRepository mockRepo;
  late CreatePool useCase;

  final pool = Pool(
    externalId: 'pool-1',
    name: 'Breakfast',
    createdAt: DateTime(2024),
  );

  setUp(() {
    mockRepo = MockPoolRepository();
    useCase = CreatePool(repository: mockRepo);
  });

  test('calls repository with trimmed name', () async {
    when(mockRepo.createPool('Breakfast')).thenAnswer((_) async => pool);

    final result = await useCase(name: '  Breakfast  ');

    expect(result, pool);
    verify(mockRepo.createPool('Breakfast')).called(1);
  });

  test('throws ArgumentError for empty name', () async {
    await expectLater(
      useCase(name: ''),
      throwsA(isA<ArgumentError>()),
    );
    verifyZeroInteractions(mockRepo);
  });

  test('throws ArgumentError for whitespace-only name', () async {
    await expectLater(
      useCase(name: '   '),
      throwsA(isA<ArgumentError>()),
    );
    verifyZeroInteractions(mockRepo);
  });

  test('propagates DuplicateNameFailure from repository', () async {
    when(mockRepo.createPool('Breakfast'))
        .thenThrow(const DuplicateNameFailure('Breakfast'));

    await expectLater(
      useCase(name: 'Breakfast'),
      throwsA(isA<DuplicateNameFailure>()),
    );
  });
}
