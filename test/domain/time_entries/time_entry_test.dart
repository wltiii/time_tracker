import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

void main() {
  group('construction', () {
    test('from default', () {
      var startTime = DateTime.now().subtract(const Duration(hours: 1));
      var endTime = DateTime.now();
      var givenModel = TimeEntryModel(start: startTime, end: endTime);

      var result = TimeEntry(id: 1, model: givenModel);

      expect(result, isA<TimeEntry>());
      var resultModel = TimeEntryModel(
        start: result.start,
        end: result.end,
      );

      expect(resultModel, equals(givenModel));
    });
  });

  group('json', () {
    test('from/to', () {
      fail('Not yet implemented.');
      // var givenTimeEntry = TimeEntryModel(
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
