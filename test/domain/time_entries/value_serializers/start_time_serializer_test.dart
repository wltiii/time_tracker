import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_serializers/start_time_serializer.dart';

void main() {
  group('json', () {
    test('from', () {
      final givenIso8601String = DateTime.now().toIso8601String();

      final expectedTimeEntry = StartTime.fromIso8601String(givenIso8601String);

      expect(
        const StartTimeSerializer().fromJson(givenIso8601String),
        equals(expectedTimeEntry),
      );
    });

    test('to', () {
      final givenStartTime = StartTime();

      String expectedTimeEntry = givenStartTime.iso8601String;

      expect(
        const StartTimeSerializer().toJson(givenStartTime),
        equals(expectedTimeEntry),
      );
    });
  });
}
