import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_first_project/core/error/failures.dart';
import 'package:tdd_first_project/core/usecases/usecase.dart';
import 'package:tdd_first_project/core/util/input_converter.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_first_project/feature/number_trivia/presentation/blocs/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumbertrivia, InputConverter, GetRandomNumberTrivia])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumbertrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumbertrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumbertrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be Empty', () {
    expect(bloc.initialState, equals(NumberTriviaInitial()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    final tNumberParsed = int.parse(tNumberString);
    final tNumberTrivia =
        NumberTrivia(text: 'test trivia', number: tNumberParsed);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsigned(tNumberString))
          .thenAnswer((_) => Right(tNumberParsed));
      when(mockGetConcreteNumberTrivia(const Params(number: 1)))
          .thenAnswer((realInvocation) async => Right(tNumberTrivia));
    }

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer ',
        () async {
      setUpMockInputConverterSuccess();
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(mockInputConverter.stringToUnsigned(tNumberString));
      verify(mockInputConverter.stringToUnsigned(tNumberString));
    });
    blocTest(
      'should emit [Error] when the input is invalid',
      build: () {
        return bloc;
      },
      act: (NumberTriviaBloc bloc) {
        when(mockInputConverter.stringToUnsigned('abc'))
            .thenAnswer((_) => Left(InvalidInputFailure()));
        bloc.add(const GetTriviaForConcreteNumber(numberString: 'abc'));
      },
      expect: () =>
          [const NumberTriviaError(error: INVALID_INPUT_FAILURE_MESSAGE)],
    );

    test('should get data from the concrete use case', () async {
      setUpMockInputConverterSuccess();
      bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      await untilCalled(
          mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    blocTest(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        return bloc;
      },
      act: (NumberTriviaBloc bloc) {
        setUpMockInputConverterSuccess();

        bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      },
      expect: () => [
        NumberTriviaLoading(),
        NumberTriviaLoaded(numberTrivia: tNumberTrivia)
      ],
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails',
      build: () {
        return bloc;
      },
      act: (NumberTriviaBloc bloc) {
        when(mockInputConverter.stringToUnsigned(any))
            .thenAnswer((_) => Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      },
      expect: () => [
        NumberTriviaLoading(),
        const NumberTriviaError(error: SERVER_FAILURE_MESSAGE)
      ],
    );
    blocTest(
      'should emit [Loading, Error] when getting data fails CacheFailure',
      build: () {
        return bloc;
      },
      act: (NumberTriviaBloc bloc) {
        when(mockInputConverter.stringToUnsigned(any))
            .thenAnswer((_) => Right(tNumberParsed));
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
      },
      expect: () => [
        NumberTriviaLoading(),
        const NumberTriviaError(error: CACHE_FAILURE_MESSAGE)
      ],
    );
  });

  group('GetRandomNumberTrivia', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
    void setUpMockInputConverterSuccess() {
      when(mockGetRandomNumberTrivia(NoParams()))
          .thenAnswer((_) async => const Right(tNumberTrivia));
    }

    test(
      'should get data from the random use case',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(NoParams()));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    blocTest('should emit [Loading, Loaded] when data is gotten successfully',
        build: () => bloc,
        act: (NumberTriviaBloc bloc) {
          setUpMockInputConverterSuccess();
          bloc.add(GetTriviaForRandomNumber());
        },
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaLoaded(numberTrivia: tNumberTrivia)
            ]);

    blocTest('should emit [Loading, Error] when getting data fails',
        build: () => bloc,
        act: (NumberTriviaBloc bloc) {
          when(mockGetRandomNumberTrivia(NoParams()))
              .thenAnswer((_) async => Left(ServerFailure()));
          bloc.add(GetTriviaForRandomNumber());
        },
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaError(error: SERVER_FAILURE_MESSAGE)
            ]);

    blocTest('should emit [Loading, Error] when getting data fails',
        build: () => bloc,
        act: (NumberTriviaBloc bloc) {
          when(mockGetRandomNumberTrivia(NoParams()))
              .thenAnswer((_) async => Left(CacheFailure()));
          bloc.add(GetTriviaForRandomNumber());
        },
        expect: () => [
              NumberTriviaLoading(),
              const NumberTriviaError(error: CACHE_FAILURE_MESSAGE)
            ]);
  });
}
