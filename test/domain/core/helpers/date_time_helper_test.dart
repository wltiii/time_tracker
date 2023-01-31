import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/core/helpers/date_time_helper.dart';

void main() {
  group('epoch', () {
    test('returns 1970-01-01 UTC', () {
      expect(
        DateTimeHelper.epoch(),
        DateTime.parse('1970-01-01T00:00:00.000Z'),
      );
    });
  });

  group('min/max date tests', () {
    test('startOfTime returns date that is 100 million days from the epoch',
        () {
      expect(
        DateTimeHelper.startOfTime(),
        equals(DateTime.utc(-271821, 04, 20)),
      );
    });

    test('endOfTime returns date that is 100 million days from the epoch', () {
      expect(
        DateTimeHelper.endOfTime(),
        equals(DateTime.utc(275760, 09, 13)),
      );
    });
  });
}
