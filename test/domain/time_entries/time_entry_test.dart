import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

void main() {
  group('construction', () {
    test('from default', () {
      var startTime = DateTime.now().subtract(const Duration(hours: 1));
      var endTime = DateTime.now();
      var model = TimeEntryModel(start: startTime, end: endTime);

      var entity = TimeEntry(id: 1, model: model);

      expect(entity, isA<TimeEntry>());
      expect(entity.start, equals(model.start));
    });
  });
}
