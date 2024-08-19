import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_bloc/core/secrets/constant.dart';
import 'package:test_bloc/core/utils/input_converter.dart';
import 'package:test_bloc/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:test_bloc/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:test_bloc/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(NumberTriviaInitial()) {
    on<GetTriviaForConreteNumber>((event, emit) async {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      inputEither.fold(
        (failure) {
          emit(NumberTriviaInitial());
          emit(const NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE));
        },
        (integer) async {
          // write code here for 3rd test fix this block
          // Attempt to get trivia data
          final triviaEither =
              await getConcreteNumberTrivia(Params(number: integer));

          triviaEither.fold(
            (failure) =>
                emit(const NumberTriviaError(message: "Failed to get trivia")),
            (trivia) => emit(NumberTriviaLoaded(trivia: trivia)),
          );
        },
      );
    });
    on<GetTriviaForRandomNumber>((event, emit) {
      // TODO: implement event handler
    });
  }
}
