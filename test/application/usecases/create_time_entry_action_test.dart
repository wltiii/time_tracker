import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/application/usecases/create_time_entry/create_time_entry_action.dart';
import 'package:time_tracker/domain/core/extensions/either.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';

import '../../infrastructure/repositories/mock_time_entry_repository.dart';

void main() {
  group('CreateTimeEntryAction', () {
    test('time entry created when no existing entries', () async {
      final repository = MockTimeEntryRepository();
      final action = CreateTimeEntryAction(repository);
      final timeEntryModel = TimeEntryModel(
        start: StartTime(dateTime: DateTime.now()),
        end: EndTime(),
      );

      final result = await action(timeEntryModel);

      Failure? failure;
      TimeEntry? resultEntry;

      result.fold(
        (l) => failure = l,
        (r) => resultEntry = r,
      );
      var rightEntry = result.right();

      expect(result.isRight(), isTrue);
      expect(resultEntry, equals(rightEntry));
      expect(resultEntry!.id, equals(TimeEntryId('1')));
    });
  });
}
