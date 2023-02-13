import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/application/usecases/stop_timer/stop_timer_action.dart';
import 'package:time_tracker/domain/core/extensions/date_time.dart';
import 'package:time_tracker/domain/core/extensions/either.dart';
import 'package:time_tracker/domain/error/additional_info.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';

import '../../../infrastructure/repositories/time_entry_repository_mock.dart';

void main() {
  group('StopTimerAction', () {
    test('existing running timer stops', () async {
      final repository = TimeEntryRepositoryMock();
      final givenExistingStartTime = StartTime(dateTime: DateTime.now());
      final givenExistingEndTime = EndTime.endOfTime();
      final givenExistingEntryModel = TimeEntryModel(
        startTime: givenExistingStartTime,
        endTime: givenExistingEndTime,
      );

      final givenExistingTimeEntry =
          await repository.add(givenExistingEntryModel);

      if (givenExistingTimeEntry.isLeft()) {
        fail(
          'Test setup failure. Could not add time entry to '
          'repository. TimeEntry: $givenExistingEntryModel',
        );
      }

      // final result = await repository.get(givenExistingTimeEntry.right()!.id);

      // if (result.isLeft()) {
      //   fail('Get should not return left');
      // }
      //
      // final timeEntry = result.right()!;
      final action = StopTimerAction(repository);

      final result = await action(givenExistingTimeEntry.right()!.id);

      result.fold(
        (l) {
          fail('Updating a timer should not fail.');
        },
        (r) {
          expect(r.id, equals(TimeEntryId('1')));
          expect(r.end.dateTime.inRange(DateTimeRange()),
              equals(TimeEntryId('1')));
          expect(r.end.dateTime, isNot((equals(TimeEntryId('1'))));
          expect(r.end.dateTime.inRange(DateTimeRange()),
              equals(TimeEntryId('1')));
        },
      );
    });

    test('when no entries already exist', () async {
      final repository = TimeEntryRepositoryMock();
      final action = StopTimerAction(repository);

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

    test('when existing timer is not running throw', () async {
      final repository = TimeEntryRepositoryMock();
      final action = StopTimerAction(repository);

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

    test('when stop time is less than start it throws', () async {
      final expectedFailure = InvalidStateFailure(
        AdditionalInfo('Time entry overlaps with an existing time entry.'),
      );

      // initialize repo with entry that the result will overlap
      final repository = TimeEntryRepositoryMock();
      await StopTimerAction(repository).call();
      final result = await StopTimerAction(repository).call();

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

      final result = await StopTimerAction(repository).call();

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
