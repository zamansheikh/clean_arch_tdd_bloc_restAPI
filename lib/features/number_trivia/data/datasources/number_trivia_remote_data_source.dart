import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_bloc/core/error/exception.dart';
import 'package:test_bloc/core/secrets/app_key.dart';
import 'package:test_bloc/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:test_bloc/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTrivia> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response =
        await client.get(Uri.parse('$TRIVIABASE_API_URL$number'), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return Future.value(
          NumberTriviaModel.fromJson(json.decode(response.body)));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTrivia> getRandomNumberTrivia() async {
    final response = await client.get(Uri.parse('${TRIVIABASE_API_URL}random'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
