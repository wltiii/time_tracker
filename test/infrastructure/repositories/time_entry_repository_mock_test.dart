import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/core/extensions/either.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';

import '../../infrastructure/repositories/time_entry_repository_mock.dart';

void main() {
  group('add', () {
    test('returns Either(Right(TimeEntry))', () async {
      final repository = TimeEntryRepositoryMock();
      final givenModel = TimeEntryModel(
        start: StartTime(dateTime: DateTime.now()),
        end: EndTime.endOfTime(),
      );

      final result = await repository.add(givenModel);

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

  group('delete', () {
    test('returns Either(Right(TimeEntry))', () async {
      final repository = TimeEntryRepositoryMock();
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

      final result = await repository.delete(givenAddedTimeEntry.right()!);

      result.fold(
        (l) {
          fail('Add should not return left');
        },
        (r) {
          expect(r, isTrue);
        },
      );
    });
  });

  group('get', () {
    test('returns Either(Right(TimeEntry))', () async {
      final repository = TimeEntryRepositoryMock();
      final givenStartTime = StartTime(dateTime: DateTime.now());
      final givenEndTime = EndTime.endOfTime();
      final givenModel = TimeEntryModel(
        start: givenStartTime,
        end: givenEndTime,
      );

      final givenAddedTimeEntry = await repository.add(givenModel);

      expect(
        givenAddedTimeEntry.isRight(),
        isTrue,
        reason: 'Test setup failure. Could not add time entry to '
            'repository. TimeEntry: $givenModel',
      );

      final result = await repository.get(givenAddedTimeEntry.right()!.id);

      result.fold(
        (l) {
          fail('Get should not return left');
        },
        (r) {
          expect(r.id, isNotNull);
          expect(r.id, equals(TimeEntryId('1')));
          expect(r.start, equals(givenStartTime));
          expect(r.end, equals(givenEndTime));
        },
      );
    });

    test('returns Either(Left(Failure))', () async {
      final repository = TimeEntryRepositoryMock();
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
  });
}
