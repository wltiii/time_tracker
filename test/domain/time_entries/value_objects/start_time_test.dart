import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

void main() {
  test('without args', () {
    var lowerBound = DateTime.now();
    var result = StartTime();
    var upperBound = DateTime.now();

    expect(result, isA<StartTime>());
    expect(result.dateTime.isBefore(lowerBound), isFalse);
    expect(result.dateTime.isAfter(upperBound), isFalse);
    expect(result.iso8601String, equals(result.dateTime.toIso8601String()));
    print(lowerBound.toString());
    print(result.toString());
    print(upperBound.toString());
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

  test('throws when constructing with date more than seven days old', () {
    final pastDate = DateTime.now().subtract(const Duration(days: 7));

    expect(
      () => StartTime(dateTime: pastDate),
      throwsA(
        predicate(
          (e) =>
              e is ValueException &&
              e.message ==
                  'Invalid value. '
                      'Start time cannot be more than 7 days ago.',
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
}
