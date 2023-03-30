import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/core/helpers/date_time_helper.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

void main() {
  group('constructs', () {
    test('from datetime', () {
      var endTime = DateTime.now().subtract(const Duration(hours: 1));

      var result = EndTime(dateTime: endTime);

      expect(result.dateTime, equals(endTime));
      expect(result.isInfinite, isFalse);
    });

    test('from now constructor', () {
      var lowerBound = DateTime.now();
      var result = EndTime.now();
      var upperBound = DateTime.now();

      expect(result, isA<EndTime>());
      expect(result.dateTime.isBefore(lowerBound), isFalse);
      expect(result.dateTime.isAfter(upperBound), isFalse);
      expect(result.iso8601String, equals(result.dateTime.toIso8601String()));
      expect(result.isInfinite, isFalse);
    });

    test('from endOfTime constructor', () {
      var result = EndTime.endOfTime();

      expect(result, isA<EndTime>());
      expect(result, isA<EndTime>());
      expect(
        result.endTimestamp,
        Timestamp.fromDate(
          DateTime.parse(
            '9999-12-31T23:59:59Z',
          ),
        ),
      );
      expect(result.dateTime, DateTimeHelper.firestoreMaxDate());
      expect(result.iso8601String,
          equals(DateTimeHelper.firestoreMaxDate().toIso8601String()));
      expect(result.isInfinite, isTrue);
    });

    test('from iso8601String', () {
      var givenIso8601String = DateTime.now().toIso8601String();
      var expected = DateTime.parse(givenIso8601String);

      var result = EndTime.fromIso8601String(givenIso8601String);

      expect(result.dateTime, equals(expected));
      expect(result.toString(), equals(expected.toString()));
      expect(result.isInfinite, isFalse);
    });

    test('throws when constructing from future date', () {
      var futureDate = DateTime.now().add(const Duration(days: 365));

      expect(
        () => EndTime(dateTime: futureDate),
        throwsA(
          predicate(
            (e) =>
                e is ValueException &&
                e.message ==
                    'Invalid value. '
                        'End time cannot be after the current time.',
          ),
        ),
      );
    });

    test('throws on invalid string using fromIso8601String constructor', () {
      expect(
        () => EndTime.fromIso8601String('invalid string'),
        throwsA(
          predicate(
            (e) => e is FormatException && e.message == 'Invalid date format',
          ),
        ),
      );
    });
  });

  group('functions', () {
    test('isAfter returns true', () {
      var givenStartTime = StartTime(startTime: DateTime.now());
      var result = EndTime.now();

      expect(result.isAfter(givenStartTime), isTrue);
    });

    test('isAfter returns false', () {
      var result = EndTime.now();
      var givenStartTime = StartTime(startTime: DateTime.now());

      expect(result.isAfter(givenStartTime), isFalse);
    });

    test('difference returns duration difference', () {
      const duration = Duration(seconds: 1);
      final now = DateTime.now();
      final givenEndTime = EndTime(dateTime: now);
      final givenStartTime = StartTime(startTime: now.subtract(duration));
      final result = givenEndTime.difference(givenStartTime);

      expect(result, equals(duration));
    });
  });

  group('equality', () {
    test('equal', () {
      final givenIsoString = DateTime.now().toIso8601String();

      var x = EndTime.fromIso8601String(givenIsoString);
      var y = EndTime.fromIso8601String(givenIsoString);

      expect(x, equals(y));
    });

    test('not equal', () {
      final x = EndTime.fromIso8601String(
        DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      );
      final y = EndTime.fromIso8601String(DateTime.now().toIso8601String());

      expect(x, isNot(equals(y)));
    });
  });
}
