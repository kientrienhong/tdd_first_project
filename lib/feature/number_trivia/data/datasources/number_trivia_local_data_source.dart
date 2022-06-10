import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_first_project/core/error/exception.dart';

import 'package:tdd_first_project/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/entities/number_trivia.dart';

const String CACHED_NUMBER = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTribiaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTribiaLocalDataSource {
  final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
        CACHED_NUMBER, json.encode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }
}
