import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/core/extensions/either.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';

import '../../../lib/infrastructure/repositories/time_entry_repository_mock.dart';

void main() {
  group('add', () {
    test('returns Either(Right(TimeEntry))', () async {
      final repository = TimeEntryRepositoryMock();
      final givenModel = TimeEntryModel(
        startTime: StartTime(dateTime: DateTime.now()),
        endTime: EndTime.endOfTime(),
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
        startTime: StartTime(dateTime: DateTime.now()),
        endTime: EndTime.endOfTime(),
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
      final repository = TimeEntryRepositoryMock();
      final givenStartTime = StartTime(dateTime: DateTime.now());
      final givenEndTime = EndTime.endOfTime();
      final givenModel = TimeEntryModel(
        startTime: givenStartTime,
        endTime: givenEndTime,
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
      expect(timeEntry.id, equals(TimeEntryId('1')));
      expect(timeEntry.start, equals(givenStartTime));
      expect(timeEntry.end, equals(givenEndTime));
    });

    test('returns Either(Left(Failure))', () async {
      final repository = TimeEntryRepositoryMock();
      final givenModel = TimeEntryModel(
        startTime: StartTime(dateTime: DateTime.now()),
        endTime: EndTime.endOfTime(),
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
