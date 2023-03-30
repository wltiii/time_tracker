import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_range.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

void main() {
  group('construction', () {
    test('from valid start/end range', () {
      final startDateTime = DateTime.now().subtract(const Duration(hours: 1));
      final startTime = StartTime(startTime: startDateTime);
      final endTime = EndTime.endOfTime();

      final result = TimeEntryRange(
        startTime: startTime,
        endTime: endTime,
      );

      expect(result, isA<TimeEntryRange>());
      expect(result, isA<DateTimeRange>());
      expect(result.startTime, equals(startTime));
      expect(result.endTime, equals(endTime));
    });

    test('throws when start and end are equal', () {
      final now = DateTime.now();
      final startTime = StartTime(startTime: now);
      final endTime = EndTime(dateTime: now);

      expect(
        () => TimeEntryRange(
          startTime: startTime,
          endTime: endTime,
        ),
        throwsA(
          predicate(
            (e) =>
                e is ValueException &&
                e.message ==
                    'Invalid value. Start time must be before end time.',
          ),
        ),
      );
    });

    //TODO(wltiii): ask Randal how to test this such that it is not caught by the assertion
    // test('throws when start is greater than end', () {
    //   final now = DateTime.now();
    //   final startTime = StartTime(startTime: now);
    //   final endTime = EndTime(dateTime: now.subtract(const Duration(hours: 1)));
    //
    //   expect(
    //     () => TimeEntryRange(
    //       startTime: startTime,
    //       endTime: endTime,
    //     ),
    //     throwsA(
    //       predicate(
    //         (e) =>
    //             e is ValueException &&
    //             e.message ==
    //                 'Invalid value. Start time must be before end time.',
    //       ),
    //     ),
    //   );
    // });
  });
}
