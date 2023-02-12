import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

void main() {
  group('constructs', () {
    test('default', () {
      const givenId = 'abc123';

      var result = TimeEntryId(givenId);

      expect(result, isA<TimeEntryId>());
      expect(result, isA<Id>());
      expect(result.id, equals(givenId));
    });
  });

  group('equality', () {
    test('equal', () {
      const givenId = 'abc123';

      final x = TimeEntryId(givenId);
      final y = TimeEntryId(givenId);

      expect(x, equals(y));
    });

    test('not equal', () {
      final x = TimeEntryId('abc123');
      final y = TimeEntryId('123abc');

      expect(x, isNot(equals(y)));
    });
  });
}
