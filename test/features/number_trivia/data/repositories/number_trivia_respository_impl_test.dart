import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_first_project/core/error/exception.dart';
import 'package:tdd_first_project/core/error/failures.dart';
import 'package:tdd_first_project/core/platform/network_info.dart';
import 'package:tdd_first_project/feature/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_first_project/feature/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_first_project/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_first_project/feature/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_respository_impl_test.mocks.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTribiaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

@GenerateMocks([MockRemoteDataSource, MockLocalDataSource, MockNetworkInfo])
void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockMockLocalDataSource();
    mockRemoteDataSource = MockMockRemoteDataSource();
    mockNetworkInfo = MockMockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const NumberTriviaModel triviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    const NumberTrivia tNumberTrivia = triviaModel;
    test('should check if the device is online', () {
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => triviaModel);
      repositoryImpl.getConcreteNumberTrivia(tNumber);

      verify(mockNetworkInfo.isConnected());
    });

    runTestsOnline(() {
      test(
          'shoule return remote data when the call to remote data source is successful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => triviaModel);

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => triviaModel);

        await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));

        verify(mockLocalDataSource.cacheNumberTrivia(triviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => triviaModel);

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, const Right(tNumberTrivia));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repositoryImpl.getConcreteNumberTrivia(tNumber);

        verifyNoMoreInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    const tNumber = 1;
    const NumberTriviaModel triviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    const NumberTrivia tNumberTrivia = triviaModel;
    test('should check if the device is online', () {
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => triviaModel);
      repositoryImpl.getRandomNumberTrivia();

      verify(mockNetworkInfo.isConnected());
    });

    runTestsOnline(() {
      test(
          'shoule return remote data when the call to remote data source is successful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => triviaModel);

        final result = await repositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());

        expect(result, equals(const Right(tNumberTrivia)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => triviaModel);

        await repositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());

        verify(mockLocalDataSource.cacheNumberTrivia(triviaModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        when(mockRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());

        final result = await repositoryImpl.getRandomNumberTrivia();

        verify(mockRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => triviaModel);

        final result = await repositoryImpl.getRandomNumberTrivia();
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, const Right(tNumberTrivia));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repositoryImpl.getRandomNumberTrivia();

        verifyNoMoreInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, Left(CacheFailure()));
      });
    });
  });
}
