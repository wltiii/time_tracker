import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

void main() {
  test('without args is infinite', () {
    var result = EndTime();

    expect(result, isA<EndTime>());
    expect(result.dateTime.toUtc(), equals(DateTime.utc(275760, 09, 13)));
    expect(result.toString(), equals('275760-09-13 00:00:00.000Z'));
  });

  test('from now constructor', () {
    var lowerBound = DateTime.now();
    var result = EndTime.now();
    var upperBound = DateTime.now();

    expect(result, isA<EndTime>());
    expect(result.dateTime.isBefore(lowerBound), isFalse);
    expect(result.dateTime.isAfter(upperBound), isFalse);
    expect(result.iso8601String, equals(result.dateTime.toIso8601String()));
  });

  test('from valid datetime arg', () {
    var endTime = DateTime.now().subtract(const Duration(hours: 1));

    var result = EndTime(dateTime: endTime);

    expect(result.dateTime, equals(endTime));
  });

  test('from iso8601String', () {
    var givenIso8601String = DateTime.now().toIso8601String();
    var expected = DateTime.parse(givenIso8601String);

    var result = EndTime.fromIso8601String(givenIso8601String);

    expect(result.dateTime, equals(expected));
    expect(result.toString(), equals(expected.toString()));
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

  test('throws when constructing with date more than seven days old', () {
    final pastDate = DateTime.now().subtract(const Duration(days: 7));

    expect(
      () => EndTime(dateTime: pastDate),
      throwsA(
        predicate(
          (e) =>
              e is ValueException &&
              e.message ==
                  'Invalid value. '
                      'End time cannot be more than 7 days ago.',
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
}
