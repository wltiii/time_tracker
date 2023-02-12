import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/services/time_entry_validation_service.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_boxed_entries.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';

void main() {
  group('dateTimeRangeIsConsistent validation', () {
    test('returns true when there are no other entries', () async {
      final givenModel = TimeEntryModel.validatedRunningEntry(
        timeBoxedEntries: TimeBoxedEntries(
          start: StartTime(),
          end: EndTime.endOfTime(),
          timeEntryList: [],
        ),
      );

      final service = TimeEntryValidationService();

      final result = service.dateTimeRangeIsConsistent(
        modelToValidate: givenModel,
        existingEntries: [],
      );

      expect(result, isTrue);
    });

    test('returns true when there is no overlap', () async {
      final givenExistingTimeEntries = [
        TimeEntry(
          id: TimeEntryId('existing_1'),
          start: DateTime.now().subtract(const Duration(days: 7)),
          end: DateTime.now().subtract(const Duration(days: 1)),
        )
      ];
      final givenNonOverlappingModel = TimeEntryModel.validatedRunningEntry(
        timeBoxedEntries: TimeBoxedEntries(
          start: StartTime(),
          end: EndTime.endOfTime(),
          timeEntryList: [],
        ),
      );

      final service = TimeEntryValidationService();

      final result = service.dateTimeRangeIsConsistent(
        modelToValidate: givenNonOverlappingModel,
        existingEntries: givenExistingTimeEntries,
      );

      expect(result, isTrue);
    });

    test('returns false when there is an overlap', () async {
      final givenExistingTimeEntries = [
        TimeEntry(
          id: TimeEntryId('existing_1'),
          start: DateTime.now().subtract(const Duration(days: 7)),
          end: DateTime.now().subtract(const Duration(days: 1)),
        )
      ];
      final givenOverlappingModel = TimeEntryModel(
        startTime: StartTime(
            dateTime: DateTime.now().subtract(const Duration(days: 5))),
        endTime: EndTime(dateTime: DateTime.now()),
      );

      final result = TimeEntryValidationService().dateTimeRangeIsConsistent(
        modelToValidate: givenOverlappingModel,
        existingEntries: givenExistingTimeEntries,
      );

      expect(result, isFalse);
    });
  });
}
