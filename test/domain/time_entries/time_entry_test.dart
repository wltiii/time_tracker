import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';

void main() {
  group('construction', () {
    test('running time entry', () {
      final startDateTime = DateTime.now().subtract(const Duration(hours: 1));
      final startTime = StartTime(dateTime: startDateTime);
      final endTime = EndTime();
      final givenModel = TimeEntryModel(start: startTime, end: endTime);

      final result = TimeEntry(
        id: TimeEntryId('abc123'),
        start: startDateTime,
        end: DateTime.utc(275760, 09, 13),
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
    });
  });

  group('json', () {
    /// TODO(wltiii): should this raise all model objects to top level, or should entity json have a model object? I think the former.
    /// i.e
    ///
    /// {
    ///     id: 23456789
    ///     start: 2023-01-05T13:55:54.163113,
    ///     end: 2023-01-05T14:55:54.164525
    /// }
    /// - or -
    /// {
    ///     id: 23456789
    ///     model: {
    ///         start: 2023-01-05T13:55:54.163113,
    ///         end: 2023-01-05T14:55:54.164525
    ///     }
    /// }
    ///
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
