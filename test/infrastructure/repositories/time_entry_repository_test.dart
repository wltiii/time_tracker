import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/core/extensions/either.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';
import 'package:time_tracker/infrastructure/repositories/time_entry_repository_impl.dart';

void main() {
  group('add', () {
    test('returns Either(Right(TimeEntry))', () async {
      final firestore = FakeFirebaseFirestore();

      final repository = TimeEntryRepositoryImpl(firestore);
      var givenStartTime = StartTime(dateTime: DateTime.now());
      var givenEndTime = EndTime.endOfTime();
      final givenModel = TimeEntryModel(
        start: givenStartTime,
        end: givenEndTime,
      );

      final result = await repository.add(givenModel);

      result.fold(
        (l) {
          fail('Add should not return left');
        },
        (r) {
          expect(r.start, equals(givenStartTime));
          expect(r.end, equals(givenEndTime));
          expect(r.value, isNotEmpty);
        },
      );
    });
  });

  group('delete', () {
    test('returns Either(Right(TimeEntry))', () async {
      final firestore = FakeFirebaseFirestore();

      final repository = TimeEntryRepositoryImpl(firestore);
      final givenModel = TimeEntryModel(
        start: StartTime(dateTime: DateTime.now()),
        end: EndTime.endOfTime(),
      );

      final givenAddedTimeEntry = await repository.add(givenModel);

      if (givenAddedTimeEntry.isLeft()) {
        fail(
          'Test setup failure. Could not add time entry to '
          'repository. TimeEntry: $givenModel',
        );
      }

      final result = await repository.delete(givenAddedTimeEntry.right()!);

      if (result.isLeft()) {
        fail('Add should not return left');
      }

      expect(result.right(), isTrue);
    });
  });

  group('get', () {
    test('returns Either(Right(TimeEntry))', () async {
      final firestore = FakeFirebaseFirestore();

      final repository = TimeEntryRepositoryImpl(firestore);
      final givenStartTime = StartTime(dateTime: DateTime.now());
      final givenEndTime = EndTime.endOfTime();
      final givenModel = TimeEntryModel(
        start: givenStartTime,
        end: givenEndTime,
      );

      final givenAddedTimeEntry = await repository.add(givenModel);

      if (givenAddedTimeEntry.isLeft()) {
        fail(
          'Test setup failure. Could not add time entry to '
          'repository. TimeEntry: $givenModel',
        );
      }

      final result = await repository.get(givenAddedTimeEntry.right()!.id);

      if (result.isLeft()) {
        fail('Get should not return left');
      }

      final timeEntry = result.right()!;
      expect(timeEntry.id, isNotNull);
      // expect(timeEntry.id, equals(TimeEntryId('1')));
      expect(timeEntry.start, equals(givenStartTime));
      expect(timeEntry.end, equals(givenEndTime));
    });

    test('returns Either(Right(Stream<List<TimeEntry>>))', () async {
      final firestore = FakeFirebaseFirestore();

      final repository = TimeEntryRepositoryImpl(firestore);
      final givenStartTime = StartTime(dateTime: DateTime.now());
      final givenEndTime = EndTime.endOfTime();
      final givenModel = TimeEntryModel(
        start: givenStartTime,
        end: givenEndTime,
      );

      final givenAddedTimeEntry = await repository.add(givenModel);

      if (givenAddedTimeEntry.isLeft()) {
        fail(
          'Test setup failure. Could not add time entry to '
          'repository. TimeEntry: $givenModel',
        );
      }

      final result = repository.getList();

      if (result.isLeft()) {
        fail('Get should not return left');
      }

      // final timeEntry = result.right()!;
      // expect(timeEntry.id, isNotNull);
      // // expect(timeEntry.id, equals(TimeEntryId('1')));
      // expect(timeEntry.start, equals(givenStartTime));
      // expect(timeEntry.end, equals(givenEndTime));
    });

    test('returns NotFoundFailure', () async {
      final firestore = FakeFirebaseFirestore();

      final repository = TimeEntryRepositoryImpl(firestore);
      final givenModel = TimeEntryModel(
        start: StartTime(dateTime: DateTime.now()),
        end: EndTime.endOfTime(),
      );

      final givenAddedTimeEntry = await repository.add(givenModel);

      expect(
        givenAddedTimeEntry.isRight(),
        isTrue,
        reason: 'Test setup failure. Could not add time entry to '
            'repository. TimeEntry: $givenModel',
      );

      final result = await repository.get(TimeEntryId('x'));

      result.fold(
        (l) {
          expect(l, isA<NotFoundFailure>());
        },
        (r) {
          fail('Get should not return right when for id "x".');
        },
      );
    });

    // test('returns ServerFailure', () async {
    //   final firestore = FakeFirebaseFirestore();
    //   final repository = TimeEntryRepositoryImpl(firestore);
    //   final timeEntryId = TimeEntryId('x');
    //
    //   final auth = MockFirebaseAuth();
    //   final doc = firestore
    //       .collection(TimeEntryRepository.collection)
    //       .doc(timeEntryId.id);
    //
    //   // whenCalling(Invocation.method(#get, timeEntryId.id as Iterable<Object?>?))
    //   whenCalling(Invocation.method(#get, null))
    //       // .on(timeEntryId.id)
    //       // .on(doc)
    //       .on(auth)
    //       .thenThrow(FirebaseException(plugin: 'firestore'));
    //
    //   final result = await repository.get(timeEntryId);
    //
    //   result.fold(
    //     (l) {
    //       expect(l, isA<ServerFailure>());
    //     },
    //     (r) {
    //       fail('A ServerFailure should be returned.');
    //     },
    //   );
    // });
  });
}
