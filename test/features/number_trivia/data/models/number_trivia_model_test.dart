import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_first_project/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTrviaModel = NumberTriviaModel(
      text:
          '418 is the error code for "I\'m a teapot" in the Hyper Text Coffee Pot Control Protocol.',
      number: 418);
  test('should be a subclass of NumberTrivia', () {
    expect(tNumberTrviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test(
        'should return a valid model when the JSON number is regarded as a int',
        () async {
      Map<String, dynamic> json = jsonDecode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(json);

      expect(result, tNumberTrviaModel);
    });
    test(
        'should return a valid model when the JSON number is regarded as a double',
        () async {
      Map<String, dynamic> json = jsonDecode(fixture('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(json);

      expect(result, isA<NumberTrivia>());
    });
  });
}
