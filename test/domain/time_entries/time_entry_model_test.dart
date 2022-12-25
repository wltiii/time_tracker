import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

void main() {
  group('construction', () {
    test('from default', () {
      var startTime = DateTime.now().subtract(const Duration(hours: 1));
      var endTime = DateTime.now();

      var result = TimeEntryModel(start: startTime, end: endTime);

      expect(result, isA<TimeEntryModel>());
    });

    test('does not construct when end is not greater than start', () {
      var startTime = DateTime.now();
      var endTime = DateTime.now().subtract(const Duration(hours: 1));

      expect(
        () => TimeEntryModel(start: startTime, end: endTime),
        throwsA(
          predicate(
            (e) =>
                e is ValueException &&
                e.message == 'Invalid value. End time must be after start time.',
          ),
        ),
      );
    });
  });

  group('equality', () {
    test('same values are equal', () {
      var startTime = DateTime.now().subtract(const Duration(hours: 1));
      var endTime = DateTime.now();

      var expected = TimeEntryModel(start: startTime, end: endTime);
      var result = TimeEntryModel(start: startTime, end: endTime);

      expect(result, equals(expected));
    });

    test('different values are not equal', () {
      var startTime = DateTime.now().subtract(const Duration(hours: 1));
      var endTime = DateTime.now();
      var anotherStartTime = DateTime.now().subtract(const Duration(hours: 1));
      var anotherEndTime = DateTime.now().add(const Duration(hours: 1));
      var anotherTimeEntry = TimeEntryModel(start: anotherStartTime, end: anotherEndTime);

      var result = TimeEntryModel(start: startTime, end: endTime);

      expect(result, isNot(equals(anotherTimeEntry)));
    });
  });

  group('json', () {
    test('from json', () {
      var startTime = DateTime.now().subtract(
        const Duration(hours: 1),
      );
      var endTime = DateTime.now();
      var givenJson = {
        'start': startTime.toIso8601String(),
        'end': endTime.toIso8601String(),
      };
      var expectedTimeEntry = TimeEntryModel(
        start: startTime,
        end: endTime,
      );

      var result = TimeEntryModel.fromJson(givenJson);

      expect(result, equals(expectedTimeEntry));
    });

    test('to json', () {
      var startTime = DateTime.now().subtract(
        const Duration(hours: 1),
      );
      var endTime = DateTime.now();
      var givenTimeEntry = TimeEntryModel(
        start: startTime,
        end: endTime,
      );

      var expectedResult = {
        'start': startTime.toIso8601String(),
        'end': endTime.toIso8601String(),
      };

      var result = givenTimeEntry.toJson();
      expect(result, equals(expectedResult));
    });
  });
}
