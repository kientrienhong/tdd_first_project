import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_first_project/core/error/exception.dart';
import 'package:tdd_first_project/feature/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_first_project/feature/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

const String CACHED_NUMBER = 'CACHED_NUMBER_TRIVIA';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late NumberTriviaLocalDataSourceImpl dataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache ',
        () async {
      when(mockSharedPreferences.getString(CACHED_NUMBER))
          .thenAnswer((_) => fixture('trivia_cached.json'));

      final result = await dataSourceImpl.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a CacheException when there is not a cached value', () {
      when(mockSharedPreferences.getString('')).thenAnswer((_) => null);

      final call = dataSourceImpl.getLastNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(text: 'Test text', number: 1);

    test('should call SharedPreferences to cache the data', () {
      dataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);

      final expectedJsonString = json.encode(dataSourceImpl);
      verify(
          mockSharedPreferences.setString(CACHED_NUMBER, expectedJsonString));
    });
  });
}
