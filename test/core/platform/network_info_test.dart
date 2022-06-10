import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_first_project/core/platform/network_info.dart';

void main() {
  late NetworkInfoImpl networkInfo;

  setUp(() {
    networkInfo = NetworkInfoImpl();
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection',
        () async {
      final tHasConnectionFuture = await Future.value(true);

      final result = await networkInfo.isConnected();

      expect(result, tHasConnectionFuture);
    });
  });
}
