import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/application/usecases/start_timer/start_timer_action.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';

import '../../../infrastructure/repositories/time_entry_repository_mock.dart';

void main() {
  group('CreateTimeEntryAction', () {
    test('time entry created when no existing entries', () async {
      final repository = TimeEntryRepositoryMock();
      final action = StartTimerAction(repository);
      final timeEntryModel = TimeEntryModel(
        start: StartTime(dateTime: DateTime.now()),
        end: EndTime.endOfTime(),
      );

      final result = await action(timeEntryModel);

      result.fold(
        (l) {
          fail('Add should not return left');
        },
        (r) {
          expect(r.id, equals(TimeEntryId('1')));
        },
      );
    });
  });
}
