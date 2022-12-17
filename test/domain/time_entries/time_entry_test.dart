import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';

void main() {
  group('construction', () {
    test('from default', () {
      var startTime = DateTime.now();
      expect(TimeEntry(start: startTime), isA<TimeEntry>());
    });
  });
}
