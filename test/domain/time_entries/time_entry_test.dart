import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';

void main() {
  group('construction', () {
    test('from default', () {
      final startTime = StartTime(dateTime: DateTime.now().subtract(const Duration(hours: 1)));
      final endTime = EndTime(dateTime: DateTime.now());
      final givenModel = TimeEntryModel(start: startTime, end: endTime);

      final result = TimeEntry(id: 1, model: givenModel);

      expect(result, isA<TimeEntry>());
      final resultModel = TimeEntryModel(
        start: result.start,
        end: result.end,
      );

      expect(resultModel, equals(givenModel));
    });
  });

  group('json', () {
    test('from/to', () {
      fail('Not yet implemented.');
      // final givenTimeEntry = TimeEntryModel(
      //   start: DateTime.now().subtract(
      //     const Duration(hours: 1),
      //   ),
      //   end: DateTime.now(),
      // );
      //
      // expect(
      //   TimeEntryModel.fromJson(givenTimeEntry.toJson()),
      //   equals(givenTimeEntry),
      // );
    });
  });
}
