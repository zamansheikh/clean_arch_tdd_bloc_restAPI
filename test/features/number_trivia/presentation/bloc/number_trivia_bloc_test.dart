import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_bloc/core/error/failure.dart';
import 'package:test_bloc/core/secrets/constant.dart';
import 'package:test_bloc/core/usecases/usecase.dart';
import 'package:test_bloc/core/utils/input_converter.dart';
import 'package:test_bloc/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:test_bloc/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:test_bloc/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:test_bloc/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late MockConcreteNumberTrivia mockConcreteNumberTrivia;
  late MockRandomNumberTrivia mockRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc numberTriviaBloc;
  setUp(() {
    mockConcreteNumberTrivia = MockConcreteNumberTrivia();
    mockRandomNumberTrivia = MockRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    numberTriviaBloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockConcreteNumberTrivia,
      getRandomNumberTrivia: mockRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });
  setUpAll(() {
    registerFallbackValue(Params(number: 0)); // Create a dummy Params instance
    registerFallbackValue(NoParams()); // Create a dummy NoParams instance
  });

  test(
    "initialState should be NumberTriviaInitial",
    () async {
      // assert
      expect(numberTriviaBloc.state, equals(NumberTriviaInitial()));
    },
  );

  group(
    "GetTriviaForConcreteNumber",
    () {
      const tNumberString = "1";
      const tNumberParsed = 1;
      const tNumberTrivia = NumberTrivia(text: "test", number: 1);

      test(
        "should call the InputConverter to validate and convert the string to an unsigned integer",
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));
          when(() => mockConcreteNumberTrivia(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          // act
          numberTriviaBloc.add(
              const GetTriviaForConreteNumber(numberString: tNumberString));
          await untilCalled(
              () => mockInputConverter.stringToUnsignedInteger(any()));
          // assert
          verify(
              () => mockInputConverter.stringToUnsignedInteger(tNumberString));
        },
      );

      test(
        "should emit [NumberTriviaInitial, NumberTriviaError] when the input is invalid",
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Left(InvalidInputFailure()));

          // assert later
          final expected = [
            NumberTriviaInitial(), // This should be the initial state
            const NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE),
          ];
          expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

          // act
          numberTriviaBloc.add(
              const GetTriviaForConreteNumber(numberString: tNumberString));
        },
      );
      test(
        "should get data from the concrete use case",
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));
          when(() => mockConcreteNumberTrivia(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));

          // act
          numberTriviaBloc.add(
              const GetTriviaForConreteNumber(numberString: tNumberString));

          await untilCalled(() => mockConcreteNumberTrivia(any()));

          // assert
          verify(() => mockConcreteNumberTrivia(any())).called(1);
        },
      );
      test(
        "should emit [Loading] and [Loaded] when data is gotten successfully",
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));
          when(() => mockConcreteNumberTrivia(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));

          // assert later
          final expected = [
            NumberTriviaInitial(),
            NumberTriviaLoading(),
            const NumberTriviaLoaded(trivia: tNumberTrivia),
          ];
          expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

          // act
          numberTriviaBloc.add(
              const GetTriviaForConreteNumber(numberString: tNumberString));
        },
      );
      test(
        "should emit [Loading] and [Error] when getting data fails",
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(const Right(tNumberParsed));
          when(() => mockConcreteNumberTrivia(any()))
              .thenAnswer((_) async => Left(ServerFailure()));

          // assert later
          final expected = [
            NumberTriviaInitial(),
            NumberTriviaLoading(),
            const NumberTriviaError(message: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

          // act
          numberTriviaBloc.add(
              const GetTriviaForConreteNumber(numberString: tNumberString));
        },
      );
    },
  );

  group(
    "Get Random Number Trivia",
    () {
      const tNumberTrivia = NumberTrivia(text: "test", number: 1);
      test(
        "should get data from the concrete use case",
        () async {
          // arrange
          when(() => mockRandomNumberTrivia(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));

          // act
          numberTriviaBloc.add(GetTriviaForRandomNumber());

          await untilCalled(() => mockRandomNumberTrivia(any()));

          // assert
          verify(() => mockRandomNumberTrivia(any())).called(1);
        },
      );
      test(
        "should emit [Loading] and [Loaded] when data is gotten successfully",
        () async {
          // arrange
          when(() => mockRandomNumberTrivia(any()))
              .thenAnswer((_) async => const Right(tNumberTrivia));

          // assert later
          final expected = [
            NumberTriviaLoading(),
            const NumberTriviaLoaded(trivia: tNumberTrivia),
          ];
          expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

          // act
          numberTriviaBloc.add(GetTriviaForRandomNumber());
        },
      );
      test(
        "should emit [Loading] and [Error] when getting data fails",
        () async {
          // arrange
          when(() => mockRandomNumberTrivia(any()))
              .thenAnswer((_) async => Left(ServerFailure()));

          // assert later
          final expected = [
            NumberTriviaLoading(),
            const NumberTriviaError(message: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(numberTriviaBloc.stream, emitsInOrder(expected));

          // act
          numberTriviaBloc.add(GetTriviaForRandomNumber());
        },
      );
    },
  );
}
