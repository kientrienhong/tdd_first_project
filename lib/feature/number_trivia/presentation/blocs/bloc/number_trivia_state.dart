part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class NumberTriviaInitial extends NumberTriviaState {}

class NumberTriviaLoading extends NumberTriviaState {}

class NumberTriviaLoaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;
  const NumberTriviaLoaded({
    required this.numberTrivia,
  });
}

class NumberTriviaError extends NumberTriviaState {
  final String error;
  const NumberTriviaError({
    required this.error,
  });
}
