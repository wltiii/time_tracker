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
    // test('startOfTime returns date that is 100 million days from the epoch',
    //     () {
    //   expect(
    //     DateTimeHelper.startOfTime(),
    //     equals(DateTime.utc(-271821, 04, 20)),
    //   );
    // });
    //
    // test('endOfTime returns date that is 100 million days from the epoch', () {
    //   expect(
    //     DateTimeHelper.endOfTime(),
    //     equals(DateTime.utc(275760, 09, 13)),
    //   );
    // });
  });

  /*
  Range is from 0001-01-01T00:00:00Z to 9999-12-31T23:59:59.999999999Z
   */
  group('min/max firestore timestamp limits tests', () {
    test(
        'firestoreMinDate returns a DateTime equivalent of the min allowable timestamp',
        () {
      expect(
        DateTimeHelper.firestoreMinDate(),
        equals(DateTime.parse('0001-01-01T00:00:00Z')),
      );
    });

    test(
        'firestoreMaxDate returns a DateTime equivalent of the max allowable timestamp',
        () {
      expect(
        DateTimeHelper.firestoreMaxDate(),
        equals(DateTime.parse('9999-12-31T23:59:59Z')),
      );
    });
  });
}
