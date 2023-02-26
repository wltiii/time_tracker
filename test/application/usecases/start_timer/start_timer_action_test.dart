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
          // expect(r.id, equals(TimeEntryId('1')));
          //TODO(wltiii): rid myself of id.id
          expect(r.id.id, isNotEmpty);
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
      print('=== Adding existingEntryResult ===');
      // final existingEntryResult = await StartTimerAction(repository).call();
      final givenExistingStartTime = StartTime(dateTime: DateTime.now());
      final givenExistingEndTime = EndTime.endOfTime();
      final givenExistingEntryModel = TimeEntryModel(
        start: givenExistingStartTime,
        end: givenExistingEndTime,
      );

      final givenExistingTimeEntry =
          await repository.add(givenExistingEntryModel);
      print('Dumping after adding existing entry -->');
      final dump1 = firestore.dump();
      print(dump1);
      print('<- Dump end');

      print('=== Adding overlappingEntryResult ===');

      final overlappingEntryResult = await StartTimerAction(repository).call();

      print('Dumping after adding overlapping entry -->');
      final dump2 = firestore.dump();
      print(dump2);
      print('<- Dump end');

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

    test('when timer repo call fails it throws', () async {
      // TODO(wltiii): this test worked fine with homegrown mock. how to do with FirestoreFake? OR, restore homegrown mock for this test?
      fail(
          'Test not yet implemented. Need to mock FakeFirestore to throw on call.');
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
