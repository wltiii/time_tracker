import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_serializers/end_time_serializer.dart';

void main() {
  group('json', () {
    test('from', () {
      final givenIso8601String = DateTime.now().toIso8601String();

      final expectedTimeEntry = EndTime.fromIso8601String(givenIso8601String);

      expect(
        const EndTimeSerializer().fromJson(givenIso8601String),
        equals(expectedTimeEntry),
      );
    });

    test('to', () {
      final givenEndTime = EndTime.endOfTime();

      String expectedTimeEntry = '+275760-09-13T00:00:00.000Z';

      expect(
        const EndTimeSerializer().toJson(givenEndTime),
        equals(expectedTimeEntry),
      );
    });
  });
}
