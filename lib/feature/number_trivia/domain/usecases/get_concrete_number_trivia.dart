import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:tdd_first_project/core/error/failures.dart';
import 'package:tdd_first_project/core/usecases/usecase.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumbertrivia extends UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;
  GetConcreteNumbertrivia({
    required this.repository,
  });

  Future<Either<Failure, NumberTrivia>> execute({required int number}) async {
    return await repository.getConcreteNumberTrivia(number);
  }

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  const Params({
    required this.number,
  });

  @override
  List<Object?> get props => [number];
}
