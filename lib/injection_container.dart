import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_first_project/core/platform/network_info.dart';
import 'package:tdd_first_project/core/util/input_converter.dart';
import 'package:tdd_first_project/feature/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:tdd_first_project/feature/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:tdd_first_project/feature/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_first_project/feature/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_first_project/feature/number_trivia/presentation/blocs/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Number Trivia
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumbertrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));

  // use cases
  sl.registerLazySingleton(() => GetConcreteNumbertrivia(repository: sl()));
  sl.registerLazySingleton(
      () => GetRandomNumberTrivia(numberTriviaRepository: sl()));

  // Respotitory
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

// Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTribiaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());

  //core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
}
