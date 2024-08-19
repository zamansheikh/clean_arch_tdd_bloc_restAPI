import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_bloc/core/error/exception.dart';
import 'package:test_bloc/core/error/failure.dart';
import 'package:test_bloc/core/platform/network_info.dart';
import 'package:test_bloc/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:test_bloc/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:test_bloc/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:test_bloc/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:test_bloc/features/number_trivia/domain/entities/number_trivia.dart';

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  group(
    'Get Concrete number trivia',
    () {
      const tNumber = 1;
      const tNumberTriviaModel =
          NumberTriviaModel(text: 'test trivia', number: 1);
      const NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test(
        "should check if the device is online",
        () async {
          // arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
              .thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async {});

          // act
          await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(() => mockNetworkInfo.isConnected);
        },
      );
      group(
        'the device is online-',
        () {
          test(
            "should return remote data when the call to remote data source is successful",
            () async {
              // arrange
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) async => true);
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
                  .thenAnswer((_) async => tNumberTriviaModel);
              when(() =>
                      mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                  .thenAnswer((_) async {});
              // act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(
                  () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              expect(result, equals(const Right(tNumberTrivia)));
            },
          );
          test(
            "should cache the data locally when the call to remote data source is successful",
            () async {
              // arrange
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) async => true);
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
                  .thenAnswer((_) async => tNumberTriviaModel);
              when(() =>
                      mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                  .thenAnswer((_) async {});
              // act
              await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(
                  () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              verify(() =>
                  mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
            },
          );
          test(
            "should return server failure when the call to remote data source is usuccessful",
            () async {
              // arrange
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) async => true);
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
                  .thenThrow(ServerException());
              // act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(
                  () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              expect(result, equals(Left(ServerFailure())));
              verifyNoMoreInteractions(mockLocalDataSource);
            },
          );
        },
      );

      group(
        'the devices is offline-',
        () {
          test(
            "should return last locally cached data when the cached data is present",
            () async {
              //arrange
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) async => false);
              when(() => mockLocalDataSource.getLastNumberTrivia()).thenAnswer(
                (_) async => tNumberTriviaModel,
              );

              //act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              //assert
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              verifyZeroInteractions(mockRemoteDataSource);
              expect(result, equals(const Right(tNumberTrivia)));
            },
          );
          test(
            "should return CacheFailure when there is no cached data present",
            () async {
              //arrange
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) async => false);
              when(() => mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());

              //act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              //assert
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              verifyZeroInteractions(mockRemoteDataSource);
              expect(result, equals(Left(CacheFailure())));
            },
          );
        },
      );
    },
  );
  group(
    'Get Random number trivia',
    () {
      const tNumberTriviaModel =
          NumberTriviaModel(text: 'test trivia', number: 123);
      const NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test(
        "should check if the device is online",
        () async {
          // arrange
          when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(() => mockRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
              .thenAnswer((_) async {});

          // act
          await repository.getRandomNumberTrivia();

          // assert
          verify(() => mockNetworkInfo.isConnected);
        },
      );
      group(
        'the device is online-',
        () {
          test(
            "should return remote data when the call to remote data source is successful",
            () async {
              // arrange
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) async => true);
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);
              when(() =>
                      mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                  .thenAnswer((_) async {});
              // act
              final result = await repository.getRandomNumberTrivia();
              // assert
              verify(() => mockRemoteDataSource.getRandomNumberTrivia());
              expect(result, equals(const Right(tNumberTrivia)));
            },
          );
          test(
            "should cache the data locally when the call to remote data source is successful",
            () async {
              // arrange
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) async => true);
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);
              when(() =>
                      mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
                  .thenAnswer((_) async {});
              // act
              await repository.getRandomNumberTrivia();
              // assert
              verify(() => mockRemoteDataSource.getRandomNumberTrivia());
              verify(() =>
                  mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
            },
          );
          test(
            "should return server failure when the call to remote data source is usuccessful",
            () async {
              // arrange
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) async => true);
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenThrow(ServerException());
              // act
              final result = await repository.getRandomNumberTrivia();
              // assert
              verify(() => mockRemoteDataSource.getRandomNumberTrivia());
              expect(result, equals(Left(ServerFailure())));
              verifyNoMoreInteractions(mockLocalDataSource);
            },
          );
        },
      );

      group(
        'the devices is offline-',
        () {
          test(
            "should return last locally cached data when the cached data is present",
            () async {
              //arrange
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) async => false);
              when(() => mockLocalDataSource.getLastNumberTrivia()).thenAnswer(
                (_) async => tNumberTriviaModel,
              );

              //act
              final result = await repository.getRandomNumberTrivia();
              //assert
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              verifyZeroInteractions(mockRemoteDataSource);
              expect(result, equals(const Right(tNumberTrivia)));
            },
          );
          test(
            "should return CacheFailure when there is no cached data present",
            () async {
              //arrange
              when(() => mockNetworkInfo.isConnected)
                  .thenAnswer((_) async => false);
              when(() => mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());

              //act
              final result = await repository.getRandomNumberTrivia();
              //assert
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              verifyZeroInteractions(mockRemoteDataSource);
              expect(result, equals(Left(CacheFailure())));
            },
          );
        },
      );
    },
  );
}
