import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_bloc/core/secrets/app_key.dart';
import 'package:test_bloc/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:test_bloc/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSourceImpl;
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group(
    'Get Last Number Trivia',
    () {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(fixtureReader('trivia_cached.json'));
      test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
          // Arrange
          when(() => mockSharedPreferences.getString(any()))
              .thenReturn(fixtureReader('trivia_cached.json'));
          // Act
          final result = await dataSourceImpl.getLastNumberTrivia();
          // Assert
          verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
          expect(result, tNumberTriviaModel);
        },
      );
    },
  );
}
