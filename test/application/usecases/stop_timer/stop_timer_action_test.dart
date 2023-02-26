import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
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
import 'package:time_tracker/infrastructure/repositories/time_entry_repository_impl.dart';

void main() {
  group('StopTimerAction', () {
    test('existing running timer stops', () async {
      final firestore = FakeFirebaseFirestore();
      final repository = TimeEntryRepositoryImpl(firestore);

      final givenExistingStartTime = StartTime(dateTime: DateTime.now());
      final givenExistingEndTime = EndTime.endOfTime();
      final givenExistingEntryModel = TimeEntryModel(
        start: givenExistingStartTime,
        end: givenExistingEndTime,
      );

      final givenExistingTimeEntry =
          await repository.add(givenExistingEntryModel);

      // if (givenExistingTimeEntry.isLeft()) {
      //   fail(
      //     'Test setup failure. Could not add time entry to '
      //     'repository. TimeEntry: $givenExistingEntryModel',
      //   );
      // }

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
          //TODO(wltiii): validate dump
          //TODO(wltiii): rid myself of id.id
          expect(r.id.id, isNotEmpty);
          expect(r.end, isNot((equals(EndTime.endOfTime()))));
          expect(r.end.dateTime.inRange(expectedEndTimeRange), isTrue);
        },
      );
    });

    test(
        'when no entries found for the given time entry id returns NotFoundFailure',
        () async {
      final firestore = FakeFirebaseFirestore();
      final repository = TimeEntryRepositoryImpl(firestore);

      final givenExistingStartTime = StartTime(dateTime: DateTime.now());
      final givenExistingEndTime = EndTime.endOfTime();
      final givenExistingEntryModel = TimeEntryModel(
        start: givenExistingStartTime,
        end: givenExistingEndTime,
      );

      // final givenExistingTimeEntry =
      await repository.add(givenExistingEntryModel);

      // if (givenExistingTimeEntry.isLeft()) {
      //   fail(
      //     'Test setup failure. Could not add time entry to '
      //     'repository. TimeEntry: $givenExistingEntryModel',
      //   );
      // }

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

    test('stopping a stopped timer fails', () async {
      final firestore = FakeFirebaseFirestore();
      final repository = TimeEntryRepositoryImpl(firestore);

      final expectedFailure = InvalidStateFailure(
        AdditionalInfo('Cannot stop a timer that is already stopped.'),
      );

      final givenStoppedTimeEntryStartTime = StartTime(
        dateTime: DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
      final givenStoppedTimeEntryEndTime = EndTime(
        dateTime: DateTime.now().subtract(
          const Duration(days: 1),
        ),
      );
      final givenStoppedTimeEntryModel = TimeEntryModel(
        start: givenStoppedTimeEntryStartTime,
        end: givenStoppedTimeEntryEndTime,
      );

      final givenStoppedTimeEntry =
          await repository.add(givenStoppedTimeEntryModel);

      if (givenStoppedTimeEntry.isLeft()) {
        fail(
          'Test setup failure. Initial timer failed to stop '
          'properly. TimeEntry: ${givenStoppedTimeEntry.left()!.message}',
        );
      }

      final action = StopTimerAction(repository);
      final secondStopResult = await action(givenStoppedTimeEntry.right()!.id);

      secondStopResult.fold(
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

    test('when call to get existing entry fails it throws', () async {
      fail(
          'Test not yet implemented. Need to mock FakeFirestore to throw on call.');
      // final firestore = FakeFirebaseFirestore();
      // final repository = TimeEntryRepositoryImpl(firestore);
      //
      // whenCalling(Invocation.method(#get, null))
      //     .on(doc)
      //     .thenThrow(FirebaseException(plugin: 'firestore'));
    });

    test('when call to update fails it throws', () async {
      fail(
          'Test not yet implemented. Need to mock FakeFirestore to throw on call.');
      final firestore = FakeFirebaseFirestore();
      final repository = TimeEntryRepositoryImpl(firestore);

      //
      // whenCalling(Invocation.method(#get, null))
      //     .on(doc)
      //     .thenThrow(FirebaseException(plugin: 'firestore'));
    });
  });
}
