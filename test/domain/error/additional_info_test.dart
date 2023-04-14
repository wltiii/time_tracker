import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/core/error/additional_info.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

void main() {
  group('constructs', () {
    test('with message only', () {
      const givenMessage = 'a message';

      final additionalInfo = AdditionalInfo(givenMessage);

      expect(additionalInfo, isA<NonEmptyString>());
      expect(additionalInfo.value, equals(givenMessage));
      expect(
          additionalInfo.toString(), equals('AdditionalInfo($givenMessage)'));
      expect(additionalInfo.stringify, isTrue);
    });

    test('with validators', () {
      const givenMessage = 'a message';
      final List<Function> validators = [
        (String value) => {
              if (value.trimRight().isEmpty)
                throw StringInvalidException(
                    ExceptionMessage('It must not be empty.'))
            },
      ];
      final additionalInfo =
          AdditionalInfo(givenMessage, validators: validators);

      expect(additionalInfo, isA<NonEmptyString>());
      expect(additionalInfo.value, equals(givenMessage));
      expect(
          additionalInfo.toString(), equals('AdditionalInfo($givenMessage)'));
      expect(additionalInfo.stringify, isTrue);
    });
  });
}
