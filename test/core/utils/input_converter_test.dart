import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_bloc/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });
  group(
    'stringToUnsignedInt',
    () {
      test(
        'should return an integer when the string represents an unsigned integer',
        () {
          // arrange
          const str = '123';
          // act
          final result = inputConverter.stringToUnsignedInteger(str);
          // assert
          expect(result, const Right(123));
        },
      );
      test(
        'should return a Failure when the string is not an integer',
        () {
          // arrange
          const str = 'abc';
          // act
          final result = inputConverter.stringToUnsignedInteger(str);
          // assert
          expect(result, const Left(InvalidInputFailure()));
        },
      );
      test(
        'should return a Failure when the string is a negative integer',
        () {
          // arrange
          const str = '-123';
          // act
          final result = inputConverter.stringToUnsignedInteger(str);
          // assert
          expect(result, const Left(InvalidInputFailure()));
        },
      );
    },
  );
}
