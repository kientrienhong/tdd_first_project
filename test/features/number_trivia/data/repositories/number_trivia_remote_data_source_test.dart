import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_first_project/core/error/exception.dart';
import 'package:tdd_first_project/feature/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_first_project/feature/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

const urlConcreteNumber = 'http://numbersapi.com/1';
const urlRandomNumber = 'http://numbersapi.com/random';

@GenerateMocks([], customMocks: [MockSpec<http.Client>(as: #MockHttpClient)])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  late MockHttpClient mockHttpClient;
  final tNumber = 1;
  final tNumberTriviaModel =
      NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(String url) {
    when(mockHttpClient.get(Uri.parse(url), headers: anyNamed('headers')))
        .thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404(String url) {
    when(mockHttpClient.get(Uri.parse(url), headers: anyNamed('headers')))
        .thenAnswer(
      (_) async => http.Response('Something went wrong', 404),
    );
  }

  group('getConcreteNumberTrivia', () {
    test('should perform a GET request on a URL with number being the endpoint',
        () {
      setUpMockHttpClientSuccess200(urlConcreteNumber);

      dataSourceImpl.getConcreteNumberTrivia(tNumber);

      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/$tNumber'),
        headers: {'Content-Type': 'application/json'},
      ));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess200(urlConcreteNumber);
      final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw Exception when the response code is 404 (Not found)',
        () async {
      setUpMockHttpClientFailure404(urlConcreteNumber);
      final call = dataSourceImpl.getConcreteNumberTrivia;

      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    test('should perform a GET request on a URL with number being the endpoint',
        () async {
      setUpMockHttpClientSuccess200(urlRandomNumber);

      dataSourceImpl.getRandomNumberTrivia();

      verify(mockHttpClient.get(
        Uri.parse(urlRandomNumber),
        headers: {'Content-Type': 'application/json'},
      ));
    });
    test('should return NumberTrivia when response code is 200 (success)',
        () async {
      setUpMockHttpClientSuccess200(urlRandomNumber);

      final response = await dataSourceImpl.getRandomNumberTrivia();

      expect(response, equals(tNumberTriviaModel));
    });

    test('should return ServerException when response code is 404 (Not found)',
        () {
      setUpMockHttpClientFailure404(urlRandomNumber);

      final call = dataSourceImpl.getRandomNumberTrivia;

      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  //http://numbersapi.com/some_number to http://numbersapi.com/random
}
