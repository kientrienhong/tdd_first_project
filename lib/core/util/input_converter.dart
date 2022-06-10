import 'package:dartz/dartz.dart';
import 'package:tdd_first_project/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsigned(String str) {
    try {
      int integer = int.parse(str);
      if (integer < 0) {
        return Left(InvalidInputFailure());
      }
      return Right(integer);
    } catch (e) {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}
