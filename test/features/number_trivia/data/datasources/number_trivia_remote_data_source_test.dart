
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:test_bloc/core/error/exception.dart';
import 'package:test_bloc/core/secrets/app_key.dart';
import 'package:test_bloc/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:test_bloc/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  setUp(
    () {
      mockHttpClient = MockHttpClient();
      dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
    },
  );
  group(
    'Get concrete number Trivia',
    () {
      const tNumber = 1;
      final tNumberTriviaModel = NumberTriviaModel.fromJson(fixtureReader('trivia_cached.json'));
      test(
        "should perform a GET request on a URL with number being the endpoint and with application/json header",
        () async {
          // arrange
          when(
            () => mockHttpClient.get(
              Uri.parse('$TRIVIABASE_API_URL$tNumber'),
              headers: {'Content-Type': 'application/json'},
            ),
          ).thenAnswer(
            (_) async => http.Response(fixtureReader('trivia.json'), 200),
          );
          // act
          dataSourceImpl.getConcreteNumberTrivia(tNumber);
          // assert
          verify(
            () => mockHttpClient.get(
              Uri.parse('$TRIVIABASE_API_URL$tNumber'),
              headers: {'Content-Type': 'application/json'},
            ),
          );
        },
      );
      test(
        "should return NumberTrivia when the response code is 200",
        () async {
          // arrange
          when(
            () => mockHttpClient.get(
              Uri.parse('$TRIVIABASE_API_URL$tNumber'),
              headers: {'Content-Type': 'application/json'},
            ),
          ).thenAnswer(
            (_) async => http.Response(fixtureReader('trivia.json'), 200),
          );
          // act
          final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);
          // assert
          expect(result, tNumberTriviaModel);
        },
      );
      test(
        "should throw a ServerException when the response code is not 200",
        () async {
          // arrange
          when(
            () => mockHttpClient.get(
              Uri.parse('$TRIVIABASE_API_URL$tNumber'),
              headers: {'Content-Type': 'application/json'},
            ),
          ).thenAnswer(
            (_) async => http.Response('Something went wrong', 404),
          );
          // act
          final call = dataSourceImpl.getConcreteNumberTrivia(tNumber);
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        },
      );
    },
  );
  group(
    'Get Random number Trivia',
    () {
      final tNumberTriviaModel = NumberTriviaModel.fromJson(fixtureReader('trivia_cached.json'));
      test(
        "should perform a GET request on a URL with number being the endpoint and with application/json header",
        () async {
          // arrange
          when(
            () => mockHttpClient.get(
              Uri.parse('${TRIVIABASE_API_URL}random'),
              headers: {'Content-Type': 'application/json'},
            ),
          ).thenAnswer(
            (_) async => http.Response(fixtureReader('trivia.json'), 200),
          );
          // act
          dataSourceImpl.getRandomNumberTrivia();
          // assert
          verify(
            () => mockHttpClient.get(
              Uri.parse('${TRIVIABASE_API_URL}random'),
              headers: {'Content-Type': 'application/json'},
            ),
          );
        },
      );
      test(
        "should return NumberTrivia when the response code is 200",
        () async {
          // arrange
          when(
            () => mockHttpClient.get(
              Uri.parse('${TRIVIABASE_API_URL}random'),
              headers: {'Content-Type': 'application/json'},
            ),
          ).thenAnswer(
            (_) async => http.Response(fixtureReader('trivia.json'), 200),
          );
          // act
          final result = await dataSourceImpl.getRandomNumberTrivia();
          // assert
          expect(result, tNumberTriviaModel);
        },
      );
      test(
        "should throw a ServerException when the response code is not 200",
        () async {
          // arrange
          when(
            () => mockHttpClient.get(
              Uri.parse('${TRIVIABASE_API_URL}random'),
              headers: {'Content-Type': 'application/json'},
            ),
          ).thenAnswer(
            (_) async => http.Response('Something went wrong', 404),
          );
          // act
          final call = dataSourceImpl.getRandomNumberTrivia();
          // assert
          expect(() => call, throwsA(isA<ServerException>()));
        },
      );
    },
  );
}
