import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_first_project/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
        'should return an integer when the string representds an unsigned integer',
        () {
      const str = '123';

      final result = inputConverter.stringToUnsigned(str);

      expect(result, const Right(123));
    });

    test('should return a failure when the string is not an integer', () {
      const str = 'abc';

      final result = inputConverter.stringToUnsigned(str);

      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a failure when the string is a negative integer', () {
      const str = '-123';

      final result = inputConverter.stringToUnsigned(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}
