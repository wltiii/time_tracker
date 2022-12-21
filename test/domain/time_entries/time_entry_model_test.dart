import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

void main() {
  group('construction', () {
    test('from default', () {
      var startTime = DateTime.now();
      var model = TimeEntryModel(start: startTime, end: startTime);
      expect(TimeEntryModel(start: startTime, end: startTime), isA<TimeEntryModel>());
      expect(model.end.isBefore(model.start), isTrue);
    });
  });
}
