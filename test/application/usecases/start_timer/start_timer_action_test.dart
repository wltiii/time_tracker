import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/application/usecases/start_timer/start_timer_action.dart';
import 'package:time_tracker/domain/error/additional_info.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';

import '../../../../lib/infrastructure/repositories/time_entry_repository_mock.dart';

void main() {
  group('StartTimerAction', () {
    test('timer started when no entries already exist', () async {
      final repository = TimeEntryRepositoryMock();
      final action = StartTimerAction(repository);

      final result = await action();

      result.fold(
        (l) {
          fail('Creating a timer should not fail.');
        },
        (r) {
          expect(r.id, equals(TimeEntryId('1')));
        },
      );
    });

    test('when timer overlaps with an existing timer it throws', () async {
      final expectedFailure = InvalidStateFailure(
        AdditionalInfo('Time entry overlaps with an existing time entry.'),
      );

      // initialize repo with entry that the result will overlap
      final repository = TimeEntryRepositoryMock();
      await StartTimerAction(repository).call();
      final result = await StartTimerAction(repository).call();

      result.fold(
        (l) {
          expect(l, isA<Failure>());
          expect(l, isA<InvalidStateFailure>());
          InvalidStateFailure f = l as InvalidStateFailure;
          expect('$f', equals('$expectedFailure'));
        },
        (r) {
          fail('Overlapping time entry did not throw.');
        },
      );
    });

    test('when timer repo call fails it throws', () async {
      // initialize repo that will fail on call to getTimeBoxedEntries
      final repository = TimeEntryRepositoryMock();
      repository.fail(method: 'getTimeBoxedEntries');

      final result = await StartTimerAction(repository).call();

      result.fold(
        (l) {
          expect(l, isA<Failure>());
          expect(l, isA<ServerFailure>());
        },
        (r) {
          fail('Failing repository call did not throw.');
        },
      );
    });
  });
}
