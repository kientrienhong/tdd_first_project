import 'package:dartz/dartz.dart';

import 'package:tdd_first_project/core/error/failures.dart';
import 'package:tdd_first_project/core/usecases/usecase.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  NumberTriviaRepository numberTriviaRepository;
  GetRandomNumberTrivia({
    required this.numberTriviaRepository,
  });

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}
