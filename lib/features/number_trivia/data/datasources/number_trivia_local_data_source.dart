import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_bloc/core/error/exception.dart';
import 'package:test_bloc/core/secrets/app_key.dart';
import 'package:test_bloc/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:test_bloc/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was retrieved the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTrivia> getLastNumberTrivia();

  /// Caches the [NumberTriviaModel] to local storage.
  Future<void> cacheNumberTrivia(NumberTrivia triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTrivia triviaToCache) {
    return sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      json.encode((triviaToCache as NumberTriviaModel).toJson()),
    );
  }

  @override
  Future<NumberTrivia> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    try {
      if (jsonString != null) {
        return Future.value(
            NumberTriviaModel.fromJson(json.decode(jsonString)));
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }
}
