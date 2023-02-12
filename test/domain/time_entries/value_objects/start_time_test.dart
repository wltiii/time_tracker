import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

void main() {
  group('constructs', () {
    test('without args', () {
      var lowerBound = DateTime.now();
      var result = StartTime();
      var upperBound = DateTime.now();

      expect(result, isA<StartTime>());
      expect(result.dateTime.isBefore(lowerBound), isFalse);
      expect(result.dateTime.isAfter(upperBound), isFalse);
      expect(result.iso8601String, equals(result.dateTime.toIso8601String()));
    });

    test('from valid datetime arg', () {
      var startTime = DateTime.now().subtract(const Duration(hours: 1));

      var result = StartTime(dateTime: startTime);

      expect(result.dateTime, equals(startTime));
    });

    test('from iso8601String', () {
      var givenIso8601String = DateTime.now().toIso8601String();
      var expected = DateTime.parse(givenIso8601String);

      var result = StartTime.fromIso8601String(givenIso8601String);

      expect(result.dateTime, equals(expected));
      expect(result.toString(), equals(expected.toString()));
    });

    test('throws when constructing from future date', () {
      var futureDate = DateTime.now().add(const Duration(days: 365));

      expect(
        () => StartTime(dateTime: futureDate),
        throwsA(
          predicate(
            (e) =>
                e is ValueException &&
                e.message ==
                    'Invalid value. '
                        'Start time cannot be after the current time.',
          ),
        ),
      );
    });

    test('throws on invalid string using fromIso8601String constructor', () {
      expect(
        () => StartTime.fromIso8601String('invalid string'),
        throwsA(
          predicate(
            (e) => e is FormatException && e.message == 'Invalid date format',
          ),
        ),
      );
    });
  });

  group('equality', () {
    test('equal', () {
      final givenIsoString = DateTime.now().toIso8601String();

      var x = StartTime.fromIso8601String(givenIsoString);
      var y = StartTime.fromIso8601String(givenIsoString);

      expect(x, equals(y));
    });

    test('not equal', () {
      final x = StartTime.fromIso8601String(
        DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      );
      final y = StartTime.fromIso8601String(DateTime.now().toIso8601String());

      expect(x, isNot(equals(y)));
    });
  });
}
