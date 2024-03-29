import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_range.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

void main() {
  group('construction', () {
    test('from default', () {
      final givenStartTime = StartTime(
        startTime: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      );

      final givenEndTime = EndTime(dateTime: DateTime.now());

      var result = TimeEntryModel(start: givenStartTime, end: givenEndTime);

      expect(result, isA<TimeEntryModel>());
      expect(result.start, equals(givenStartTime));
      expect(result.end, equals(givenEndTime));
      expect(
        result.timeEntryRange.startTime,
        equals(givenStartTime),
      );
      expect(
        result.timeEntryRange.endTime,
        equals(givenEndTime),
      );
    });

    test('does not construct when end is not greater than start', () {
      final startTime = StartTime(startTime: DateTime.now());
      final endTime = EndTime(
        dateTime: DateTime.now().subtract(
          const Duration(hours: 1),
        ),
      );

      expect(
        () => TimeEntryModel(start: startTime, end: endTime),
        throwsA(
          predicate(
            (e) =>
                e is ValueException &&
                e.message ==
                    'Invalid value. End time must be after start time.',
          ),
        ),
      );
    });
  });

  group('time entry range', () {
    test('overlaps', () {
      final givenPersistedTimeRange = TimeEntryRange.fromTimeEntryModel(
        timeEntryModel: TimeEntryModel(
          start: StartTime(startTime: DateTime(2023, 02, 10, 16, 50, 21)),
          end: EndTime.endOfTime(),
        ),
      );
      final givenOverlappingModel = TimeEntryModel(
        start: StartTime(startTime: DateTime(2023, 02, 10, 16, 50, 22)),
        end: EndTime.endOfTime(),
      );

      expect(
          givenOverlappingModel.overlapsWith(givenPersistedTimeRange), isTrue);
    });

    test('does not overlap', () {
      final now = DateTime.now();
      final nowLessOneHour = now.subtract(const Duration(hours: 1));
      final nowLessTwoHours = now.subtract(const Duration(hours: 2));
      final nowLessThreeHours = now.subtract(const Duration(hours: 3));

      final givenStartTime = StartTime(startTime: nowLessOneHour);
      final givenEndTime = EndTime(dateTime: now);
      final givenOtherStartTime = StartTime(startTime: nowLessThreeHours);
      final givenOtherEndTime = EndTime(dateTime: nowLessTwoHours);

      final givenTimeEntryModel = TimeEntryModel(
        start: givenStartTime,
        end: givenEndTime,
      );
      final otherTimeRange = TimeEntryRange.fromTimeEntryModel(
        timeEntryModel: TimeEntryModel(
          start: givenOtherStartTime,
          end: givenOtherEndTime,
        ),
      );

      expect(givenTimeEntryModel.overlapsWith(otherTimeRange), isFalse);
    });
  });

  // Testing generated code seems rather silly. in the case of
  // the generated equals code, i am less comfortable skipping
  // testing it. if someone adds another property to the class but
  // fails to add it to props, you could end up with false equivalency.
  // a condition that may not manifest in other tests, and may be
  // hard to uncover in production.
  // TODO(wltiii): think about this. is there a better solution? is this going overboard?
  group('equality', () {
    test('same values are equal', () {
      final startTime = StartTime(
        startTime: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      );
      final endTime = EndTime(dateTime: DateTime.now());

      final expected = TimeEntryModel(start: startTime, end: endTime);
      final result = TimeEntryModel(start: startTime, end: endTime);

      expect(result, equals(expected));
    });

    test('different values are not equal', () {
      final startTime = StartTime(
        startTime: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      );
      final endTime = EndTime(dateTime: DateTime.now());

      final anotherStartTime = StartTime(
        startTime: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      );
      final anotherEndTime = EndTime(
        dateTime: DateTime.now().subtract(
          const Duration(
            minutes: 1,
          ),
        ),
      );

      expect(
        TimeEntryModel(start: startTime, end: endTime),
        isNot(equals(TimeEntryModel(start: anotherStartTime, end: endTime))),
      );

      expect(
        TimeEntryModel(start: startTime, end: endTime),
        isNot(equals(TimeEntryModel(start: startTime, end: anotherEndTime))),
      );
    });
  });

  // TODO(wltiii): think about this. is there a better solution? is this going overboard?
  // testing generated code seems rather silly. in the case of
  // the from/to json, we are doing much more than verifying the
  // methods have been implemented.
  //
  // Since this should normally be an easy test to implement, and
  // one that would require little maintenance as the model evolves,
  // this should not be too controversial. That said, from/to json
  // methods would likely be inherently covered by other tests, so
  // perhaps this is frivolous.
  group('json', () {
    test('from', () {
      final startTime =
          StartTime(startTime: DateTime.parse('2023-01-24T08:02:52.360342'));
      final endTime =
          EndTime(dateTime: DateTime.parse('2023-01-24T17:01:36.140342'));

      final expectedTimeEntry = TimeEntryModel(
        start: startTime,
        end: endTime,
      );

      final givenJson = {
        'start': '2023-01-24T08:02:52.360342',
        'end': '2023-01-24T17:01:36.140342',
      };

      expect(
        TimeEntryModel.fromJson(givenJson),
        equals(expectedTimeEntry),
      );
    });

    test('to', () {
      final startTime = StartTime(
        startTime: DateTime.parse('2023-01-24T08:02:52.360342'),
      );
      final endTime = EndTime(
        dateTime: DateTime.parse('2023-01-24T17:01:36.140342'),
      );

      final givenTimeEntry = TimeEntryModel(
        start: startTime,
        end: endTime,
      );

      final expectedJson = {
        'start': '2023-01-24T08:02:52.360342',
        'end': '2023-01-24T17:01:36.140342'
      };
      expect(givenTimeEntry.toJson(), equals(expectedJson));
    });
  });
}
