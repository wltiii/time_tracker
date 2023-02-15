import 'package:flutter/material.dart';
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

import '../../../../lib/infrastructure/repositories/time_entry_repository_mock.dart';

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

      final expectedEndTimeRange = DateTimeRange(
        start: StartTime().dateTime,
        end: StartTime().dateTime.add(const Duration(seconds: 5)),
      );

      final action = StopTimerAction(repository);
      final result = await action(givenExistingTimeEntry.right()!.id);

      result.fold(
        (l) {
          fail('Updating a timer should not fail.');
        },
        (r) {
          expect(r.id, equals(TimeEntryId('1')));
          expect(r.end, isNot((equals(EndTime.endOfTime()))));
          expect(r.end.dateTime.inRange(expectedEndTimeRange), isTrue);
        },
      );
    });

    test(
        'when no entries found for the given time entry id returns NotFoundFailure',
        () async {
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

      final action = StopTimerAction(repository);
      final result = await action(TimeEntryId('does-not-exist'));

      result.fold(
        (l) {
          expect(l, isA<Failure>());
          expect(l, isA<NotFoundFailure>());
        },
        (r) {
          fail('Updating a timer where no matching id exists should fail.');
        },
      );
    });

    test('when existing timer is not running fails', () async {
      final expectedFailure = InvalidStateFailure(
        AdditionalInfo('Cannot stop a timer that is already stopped.'),
      );
      final repository = TimeEntryRepositoryMock();
      final givenExistingStartTime =
          StartTime(dateTime: DateTime.now().subtract(const Duration(days: 7)));
      final givenExistingEndTime = EndTime(dateTime: DateTime.now());
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

      final action = StopTimerAction(repository);
      final result = await action(givenExistingTimeEntry.right()!.id);

      result.fold(
        (l) {
          expect(l, isA<Failure>());
          expect(l, isA<InvalidStateFailure>());
          InvalidStateFailure f = l as InvalidStateFailure;
          expect('$f', equals('$expectedFailure'));
        },
        (r) {
          fail('Stopping a timer that is not running should fail.');
        },
      );
    });

    test('when call to getTimeBoxedEntries fails it throws', () async {
      // initialize repo that will fail on call to getTimeBoxedEntries
      final repository = TimeEntryRepositoryMock();
      repository.fail(method: 'getTimeBoxedEntries');

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

      final action = StopTimerAction(repository);
      final result = await action(givenExistingTimeEntry.right()!.id);

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
