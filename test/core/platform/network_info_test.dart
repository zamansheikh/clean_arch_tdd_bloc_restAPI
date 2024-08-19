import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_bloc/core/platform/network_info.dart';

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(mockConnectivity);
  });

  test(
    "should forward the call to Connectivity.checkConnectivity",
    () async {
      // Arrange: Simulate a mobile connection.
      final tHasConnectionFuture = [ConnectivityResult.mobile];
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => tHasConnectionFuture);

      // Act: Call the isConnected getter and await the result.
      final result = await networkInfoImpl.isConnected;

      // Assert: Check if the result is true.
      verify(() => mockConnectivity.checkConnectivity());
      expect(result, true); // Comparing the actual resolved value
    },
  );
}
