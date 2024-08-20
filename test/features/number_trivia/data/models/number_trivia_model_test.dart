
import 'package:flutter_test/flutter_test.dart';
import 'package:test_bloc/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:test_bloc/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');
  test(
    "should be a subclass of NumberTrivia entity",
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );
  group('FromJson-', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final source = fixtureReader('trivia.json');
        // act
        final result = NumberTriviaModel.fromJson(source);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
    test(
      'should return a valid model when the JSON number is regarded as a double',
      () async {
        // arrange
        final source = fixtureReader('trivia.json');
        // act
        final result = NumberTriviaModel.fromJson(source);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });
  group(
    'To JSON-',
    () {
      test(
        'should return a JSON map containing the proper data',
        () async {
          // arrange
          //ALREADY ARRANGED
          // act
          final result = tNumberTriviaModel.toMap();
          // assert
          final expectedMap = {
            "text": "Test Text",
            "number": 1,
          };
          expect(result, expectedMap);
        },
      );
    },
  );
}
