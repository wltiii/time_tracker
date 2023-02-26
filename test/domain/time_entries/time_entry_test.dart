import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/core/helpers/date_time_helper.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_range.dart';

void main() {
  group('construction', () {
    test('running time entry', () {
      final startDateTime = DateTime.now().subtract(const Duration(hours: 1));
      final startTime = StartTime(dateTime: startDateTime);
      final endTime = EndTime.endOfTime();
      final givenModel = TimeEntryModel(start: startTime, end: endTime);

      final result = TimeEntry(
        id: TimeEntryId('abc123'),
        start: startDateTime,
        // end: DateTime.utc(275760, 09, 13),
        end: DateTimeHelper.firestoreMaxDate(),
      );

      expect(result, isA<TimeEntry>());
      expect(result.id, equals(TimeEntryId('abc123')));
      final resultModel = TimeEntryModel(
        start: result.start,
        end: result.end,
      );
      expect(result.isRunning, isTrue);

      expect(resultModel, equals(givenModel));
    });

    test('completed time entry', () {
      final startDateTime = DateTime.now().subtract(const Duration(hours: 1));
      final startTime = StartTime(dateTime: startDateTime);
      final endDateTime = DateTime.now();
      final endTime = EndTime(dateTime: endDateTime);
      final givenModel = TimeEntryModel(start: startTime, end: endTime);

      final result = TimeEntry(
        id: TimeEntryId('abc123'),
        start: startDateTime,
        end: endDateTime,
      );

      expect(result, isA<TimeEntry>());
      expect(result.id, equals(TimeEntryId('abc123')));
      final resultModel = TimeEntryModel(
        start: result.start,
        end: result.end,
      );
      expect(result.isRunning, isFalse);

      expect(resultModel, equals(givenModel));
      expect(result.timeEntryRange, equals(givenModel.timeEntryRange));
    });

    test('from model', () {
      final startDateTime = DateTime.now().subtract(const Duration(hours: 1));
      final startTime = StartTime(dateTime: startDateTime);
      final endDateTime = DateTime.now();
      final endTime = EndTime(dateTime: endDateTime);
      final givenModel = TimeEntryModel(start: startTime, end: endTime);

      final result = TimeEntry.fromModel(
        id: TimeEntryId('abc123'),
        model: givenModel,
      );

      expect(result, isA<TimeEntry>());
      expect(result.id, equals(TimeEntryId('abc123')));
      final resultModel = TimeEntryModel(
        start: result.start,
        end: result.end,
      );
      expect(result.isRunning, isFalse);

      expect(resultModel, equals(givenModel));
    });
  });

  group('overlapsWith', () {
    test('true when overlapping', () {
      final now = DateTime.now();
      final nowLessOneHour = now.subtract(const Duration(hours: 1));
      final nowLessTwoHours = now.subtract(const Duration(hours: 2));
      final nowLessThreeHours = now.subtract(const Duration(hours: 3));

      final givenStartTime = StartTime(dateTime: nowLessTwoHours);
      final givenOtherStartTime = StartTime(dateTime: nowLessThreeHours);
      final givenEndTime = EndTime(dateTime: now);
      final givenOtherEndTime = EndTime(dateTime: nowLessOneHour);

      final otherTimeRange = TimeEntryRange.fromTimeEntryModel(
        timeEntryModel: TimeEntryModel(
          start: givenOtherStartTime,
          end: givenOtherEndTime,
        ),
      );

      final givenTimeEntry = TimeEntry(
        id: TimeEntryId('abc123'),
        start: givenStartTime.dateTime,
        end: givenEndTime.dateTime,
      );

      expect(givenTimeEntry.overlapsWith(otherTimeRange), isTrue);
    });

    test('false when not overlapping', () {
      final now = DateTime.now();
      final nowLessOneHour = now.subtract(const Duration(hours: 1));
      final nowLessTwoHours = now.subtract(const Duration(hours: 2));
      final nowLessThreeHours = now.subtract(const Duration(hours: 3));

      final givenStartTime = StartTime(dateTime: nowLessOneHour);
      final givenEndTime = EndTime(dateTime: now);
      final givenOtherStartTime = StartTime(dateTime: nowLessThreeHours);
      final givenOtherEndTime = EndTime(dateTime: nowLessTwoHours);

      final otherTimeRange = TimeEntryRange.fromTimeEntryModel(
        timeEntryModel: TimeEntryModel(
          start: givenOtherStartTime,
          end: givenOtherEndTime,
        ),
      );

      final givenTimeEntry = TimeEntry(
        id: TimeEntryId('abc123'),
        start: givenStartTime.dateTime,
        end: givenEndTime.dateTime,
      );

      expect(givenTimeEntry.overlapsWith(otherTimeRange), isFalse);
    });
  });

  group('json', () {
    test('from', () {
      final givenStartTimeString =
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
      final givenEndTimeString = DateTime.now().toIso8601String();
      final startTime =
          StartTime(dateTime: DateTime.parse(givenStartTimeString));
      final endTime = EndTime(dateTime: DateTime.parse(givenEndTimeString));

      final expectedTimeEntry = TimeEntry(
          id: TimeEntryId('abc123'),
          start: startTime.dateTime,
          end: endTime.dateTime);

      final givenJson = {
        'id': 'abc123',
        'start': givenStartTimeString,
        'end': givenEndTimeString
      };

      expect(
        TimeEntry.fromJson(givenJson),
        equals(expectedTimeEntry),
      );
    });

    test('to', () {
      final givenStartTimeString =
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String();
      final givenEndTimeString = DateTime.now().toIso8601String();
      final startTime =
          StartTime(dateTime: DateTime.parse(givenStartTimeString));
      final endTime = EndTime(dateTime: DateTime.parse(givenEndTimeString));

      final givenTimeEntry = TimeEntry(
          id: TimeEntryId('abc123'),
          start: startTime.dateTime,
          end: endTime.dateTime);

      final expectedJson = {
        'id': 'abc123',
        'start': givenStartTimeString,
        'end': givenEndTimeString
      };

      expect(givenTimeEntry.toJson(), equals(expectedJson));
    });
  });
}
