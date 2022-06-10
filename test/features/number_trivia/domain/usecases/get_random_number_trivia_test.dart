import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_first_project/core/usecases/usecase.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/usecases/get_random_number_trivia.dart';

import 'get_random_number_trivia_test.mocks.dart';

class MockNumberTriviRepository extends Mock implements NumberTriviaRepository {
}

@GenerateMocks([MockNumberTriviRepository])
void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviRepository mockNumberTriviRepository;

  setUp(() {
    mockNumberTriviRepository = MockMockNumberTriviRepository();

    usecase = GetRandomNumberTrivia(
        numberTriviaRepository: mockNumberTriviRepository);
  });

  const NumberTrivia numberTrivia = NumberTrivia(text: 'test', number: 1);
  test('should get trivia from repository', () async {
    when(mockNumberTriviRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(numberTrivia));

    final result = await usecase(NoParams());

    expect(result, const Right(numberTrivia));

    verify(mockNumberTriviRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviRepository);
  });
}
