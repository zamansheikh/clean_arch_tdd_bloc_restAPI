import 'package:dartz/dartz.dart';
import 'package:test_bloc/core/error/failure.dart'; // Make sure you have a 'Failure' class defined
import 'package:test_bloc/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}