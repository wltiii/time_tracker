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
      print('givenAddedTimeEntry is $givenAddedTimeEntry');
      expect(
        givenAddedTimeEntry.isRight(),
        isTrue,
        reason: 'Test setup failure.',
      );

      final result = await repository.delete(givenAddedTimeEntry.right()!);

      Failure? failure;
      bool? entry;

      result.fold(
        (l) => failure = l,
        (r) => entry = r,
      );
      var rightEntry = result.right();

      expect(result.isRight(), isTrue);
      expect(entry, isTrue);
    });
  });

  group('get', () {
    test('returns Either(Right(TimeEntry))', () async {
      final repository = TimeEntryRepositoryMock();
      final givenModel = TimeEntryModel(
        start: StartTime(dateTime: DateTime.now()),
        end: EndTime.endOfTime(),
      );

      final givenAddedTimeEntry = await repository.add(givenModel);
      print('givenAddedTimeEntry is $givenAddedTimeEntry');
      expect(
        givenAddedTimeEntry.isRight(),
        isTrue,
        reason: 'Test setup failure.',
      );

      final result = await repository.get(givenAddedTimeEntry.right()!.id);

      // Failure? failure;
      // TimeEntry? entry;
      //
      // result.fold(
      //   (l) => failure = l,
      //   (r) => entry = r,
      // );
      // var rightEntry = result.right();

      expect(result.isRight(), isTrue);
      // expect(entry, isTrue);
    });

    test('returns Either(Left(Failure))', () async {
      final repository = TimeEntryRepositoryMock();
      final givenModel = TimeEntryModel(
        start: StartTime(dateTime: DateTime.now()),
        end: EndTime.endOfTime(),
      );

      final givenAddedTimeEntry = await repository.add(givenModel);
      print('givenAddedTimeEntry is $givenAddedTimeEntry');
      expect(
        givenAddedTimeEntry.isRight(),
        isTrue,
        reason: 'Test setup failure.',
      );

      final result = await repository.get(TimeEntryId('x'));

      // Failure? failure;
      // TimeEntry? entry;
      //
      // result.fold(
      //   (l) => failure = l,
      //   (r) => entry = r,
      // );
      // var rightEntry = result.right();

      expect(result.isLeft(), isTrue);
      // expect(entry, isTrue);
    });
  });
}
