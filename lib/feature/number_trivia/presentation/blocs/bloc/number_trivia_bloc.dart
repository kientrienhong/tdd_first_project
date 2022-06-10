import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_first_project/core/error/failures.dart';
import 'package:tdd_first_project/core/usecases/usecase.dart';
import 'package:tdd_first_project/core/util/input_converter.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumbertrivia getConcreteNumbertrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  @override
  NumberTriviaState get initialState => NumberTriviaInitial();

  NumberTriviaBloc(
      {required this.getConcreteNumbertrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(NumberTriviaInitial()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither = inputConverter.stringToUnsigned(event.numberString);

        NumberTriviaState state = await inputEither.fold((l) {
          return const NumberTriviaError(error: INVALID_INPUT_FAILURE_MESSAGE);
        }, (r) {
          emit(NumberTriviaLoading());

          return getConcreteNumbertrivia(Params(number: r))
              .then((value) => _eitherLoadedOrErrorState(value));
        });
        emit(state);
      } else if (event is GetTriviaForRandomNumber) {
        emit(NumberTriviaLoading());
        NumberTriviaState state = await getRandomNumberTrivia(NoParams())
            .then((value) => _eitherLoadedOrErrorState(value));

        emit(state);
      }
    });
  }

  Future<NumberTriviaState> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> either,
  ) async {
    return either.fold(
      (failure) => NumberTriviaError(error: _mapFailureToMessage(failure)),
      (trivia) => NumberTriviaLoaded(numberTrivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
