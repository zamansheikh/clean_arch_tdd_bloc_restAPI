import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_bloc/core/error/failure.dart';
import 'package:test_bloc/core/secrets/constant.dart';
import 'package:test_bloc/core/usecases/usecase.dart';
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
      emit(NumberTriviaInitial());
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      await inputEither.fold(
        // Await the result of the fold
        (failure) async {
          emit(const NumberTriviaError(message: INVALID_INPUT_FAILURE_MESSAGE));
        },
        (integer) async {
          emit(NumberTriviaLoading());
          final triviaEither =
              await getConcreteNumberTrivia(Params(number: integer));

          triviaEither.fold(
            (failure) =>
                emit(NumberTriviaError(message: _mapFailureToMessage(failure))),
            (trivia) => emit(NumberTriviaLoaded(trivia: trivia)),
          );
        },
      );
    });

    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(NumberTriviaLoading());
      final triviaEither = await getRandomNumberTrivia(NoParams());

      triviaEither.fold(
        (failure) =>
            emit(NumberTriviaError(message: _mapFailureToMessage(failure))),
        (trivia) => emit(NumberTriviaLoaded(trivia: trivia)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return SERVER_FAILURE_MESSAGE;
      case const (CacheFailure):
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
