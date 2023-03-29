import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/application/usecases/start_timer/start_timer_action.dart';
import 'package:time_tracker/domain/error/additional_info.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/infrastructure/repositories/time_entry_repository_impl.dart';

void main() {
  group('StartTimerAction', () {
    test('timer started when no entries already exist', () async {
      final firestore = FakeFirebaseFirestore();

      final repository = TimeEntryRepositoryImpl(firestore);
      final action = StartTimerAction(repository);

      final result = await action();

      result.fold(
        (l) {
          fail('Creating a timer should not fail.');
        },
        (r) {
          expect(r.value, isNotEmpty);
        },
      );
    });

    test('when timer overlaps with an existing timer it throws', () async {
      final firestore = FakeFirebaseFirestore();

      final expectedFailure = InvalidStateFailure(
        AdditionalInfo('Time entry overlaps with an existing time entry.'),
      );

      // initialize repo with entry that the result will be overlapped
      final repository = TimeEntryRepositoryImpl(firestore);
      // final existingEntryResult = await StartTimerAction(repository).call();
      final givenExistingStartTime = StartTime(startTime: DateTime.now());
      final givenExistingEndTime = EndTime.endOfTime();
      final givenExistingEntryModel = TimeEntryModel(
        start: givenExistingStartTime,
        end: givenExistingEndTime,
      );

      final givenExistingTimeEntry =
          await repository.add(givenExistingEntryModel);

      final overlappingEntryResult = await StartTimerAction(repository).call();

      overlappingEntryResult.fold(
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

    // TODO(wltiii): mock repo to throw
    test('when timer repo call fails it throws', () async {
      // final firestore = FakeFirebaseFirestore();
      //
      // final repository = TimeEntryRepositoryImpl(firestore);
      //
      // final result = await StartTimerAction(repository).call();
      //
      // result.fold(
      //   (l) {
      //     expect(l, isA<Failure>());
      //     expect(l, isA<ServerFailure>());
      //   },
      //   (r) {
      //     fail('Failing repository call did not throw.');
      //   },
      // );
    });
  });
}
