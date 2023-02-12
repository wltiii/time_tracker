import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/core/helpers/date_time_helper.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_boxed_entries.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_range.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

void main() {
  group('construction', () {
    test('from default', () {
      final givenStartTime = StartTime(
        dateTime: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      );

      final givenEndTime = EndTime(dateTime: DateTime.now());

      var result =
          TimeEntryModel(startTime: givenStartTime, endTime: givenEndTime);

      expect(result, isA<TimeEntryModel>());
      expect(result.startTime, equals(givenStartTime));
      expect(result.endTime, equals(givenEndTime));
      expect(
        result.timeEntryRange,
        equals(
          TimeEntryRange(
            startTime: givenStartTime,
            endTime: givenEndTime,
          ),
        ),
      );
    });

    test('does not construct when end is not greater than start', () {
      final startTime = StartTime(dateTime: DateTime.now());
      final endTime = EndTime(
        dateTime: DateTime.now().subtract(
          const Duration(hours: 1),
        ),
      );

      expect(
        () => TimeEntryModel(startTime: startTime, endTime: endTime),
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

    test('from runningEntry constructor', () {
      final beforeConstruction = DateTime.now();
      final result = TimeEntryModel.runningEntry();
      final afterConstruction = DateTime.now();

      expect(result, isA<TimeEntryModel>());
      expect(result.startTime.dateTime.isAfter(beforeConstruction), isTrue);
      expect(result.startTime.dateTime.isBefore(afterConstruction), isTrue);
      expect(result.endTime,
          equals(EndTime(dateTime: DateTimeHelper.endOfTime())));
    });

    test('from validatedRunningEntry constructor', () {
      final givenStartTime = StartTime();
      final timeBoxedEntries = TimeBoxedEntries(
        givenStartTime,
        EndTime.endOfTime(),
        <TimeEntry>[],
      );
      final result = TimeEntryModel.validatedRunningEntry(
        timeBoxedEntries: timeBoxedEntries,
      );

      expect(result, isA<TimeEntryModel>());
      expect(result.startTime, equals(givenStartTime));
      expect(result.endTime, equals(EndTime.endOfTime()));
    });
  });

  group('time entry range', () {
    test('overlaps', () {
      final givenPersistedTimeRange = TimeEntryRange(
        startTime: StartTime(dateTime: DateTime(2023, 02, 10, 16, 50, 21)),
        endTime: EndTime.endOfTime(),
      );
      final givenOverlappingModel = TimeEntryModel(
        startTime: StartTime(dateTime: DateTime(2023, 02, 10, 16, 50, 22)),
        endTime: EndTime.endOfTime(),
      );

      expect(
          givenOverlappingModel.overlapsWith(givenPersistedTimeRange), isTrue);
    });

    test('does not overlap', () {
      final now = DateTime.now();
      final nowLessOneHour = now.subtract(const Duration(hours: 1));
      final nowLessTwoHours = now.subtract(const Duration(hours: 2));
      final nowLessThreeHours = now.subtract(const Duration(hours: 3));

      final givenStartTime = StartTime(dateTime: nowLessOneHour);
      final givenEndTime = EndTime(dateTime: now);
      final givenOtherStartTime = StartTime(dateTime: nowLessThreeHours);
      final givenOtherEndTime = EndTime(dateTime: nowLessTwoHours);

      final givenTimeEntryModel = TimeEntryModel(
        startTime: givenStartTime,
        endTime: givenEndTime,
      );
      final otherTimeRange = TimeEntryRange(
        startTime: givenOtherStartTime,
        endTime: givenOtherEndTime,
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
        dateTime: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      );
      final endTime = EndTime(dateTime: DateTime.now());

      final expected = TimeEntryModel(startTime: startTime, endTime: endTime);
      final result = TimeEntryModel(startTime: startTime, endTime: endTime);

      expect(result, equals(expected));
    });

    test('different values are not equal', () {
      final startTime = StartTime(
        dateTime: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      );
      final endTime = EndTime(dateTime: DateTime.now());

      final anotherStartTime = StartTime(
        dateTime: DateTime.now().subtract(
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
        TimeEntryModel(startTime: startTime, endTime: endTime),
        isNot(equals(
            TimeEntryModel(startTime: anotherStartTime, endTime: endTime))),
      );

      expect(
        TimeEntryModel(startTime: startTime, endTime: endTime),
        isNot(equals(
            TimeEntryModel(startTime: startTime, endTime: anotherEndTime))),
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
  //TODO(wltiii): BROKEN for invalid invariant re: start and end times. The times can be any historical value when deserialized. Other instances, such as creating new, would have other requirements.
  group('json', () {
    test('from', () {
      final startTime =
          StartTime(dateTime: DateTime.parse('2023-01-24T08:02:52.360342'));
      final endTime =
          EndTime(dateTime: DateTime.parse('2023-01-24T17:01:36.140342'));

      final expectedTimeEntry = TimeEntryModel(
        startTime: startTime,
        endTime: endTime,
      );

      final givenJson = {
        'startTime': '2023-01-24T08:02:52.360342',
        'endTime': '2023-01-24T17:01:36.140342',
      };

      expect(
        TimeEntryModel.fromJson(givenJson),
        equals(expectedTimeEntry),
      );
    });

    test('to', () {
      final startTime = StartTime(
        dateTime: DateTime.parse('2023-01-24T08:02:52.360342'),
      );
      final endTime = EndTime(
        dateTime: DateTime.parse('2023-01-24T17:01:36.140342'),
      );

      final givenTimeEntry = TimeEntryModel(
        startTime: startTime,
        endTime: endTime,
      );

      final expectedJson = {
        'startTime': '2023-01-24T08:02:52.360342',
        'endTime': '2023-01-24T17:01:36.140342'
      };
      expect(givenTimeEntry.toJson(), equals(expectedJson));
    });
  });
}
