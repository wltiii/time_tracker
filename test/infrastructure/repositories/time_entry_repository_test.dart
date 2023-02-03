import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/application/usecases/start_timer/start_timer_command.dart';
import 'package:time_tracker/application/usecases/start_timer/start_timer_handler.dart';
import 'package:time_tracker/domain/core/extensions/either.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';

import 'time_entry_repository_mock.dart';

void main() {
  group('StartTimerHandler', () {
    test('time entry created when no existing entries', () async {
      final repository = TimeEntryRepositoryMock();
      final handler = StartTimerHandler(repository);
      final command = StartTimerCommand(
        TimeEntryModel(
          start: StartTime(dateTime: DateTime.now()),
          end: EndTime.endOfTime(),
        ),
      );

      final result = await handler.handle(command);

      Failure? failure;
      TimeEntry? entry;

      result.fold(
        (l) => failure = l,
        (r) => entry = r,
      );
      var rightEntry = result.right();

      expect(result.isRight(), isTrue);
      expect(entry, equals(rightEntry));
      expect(entry!.id, equals(TimeEntryId('1')));
    });
  });

  // TODO(wltiii): test other command handlers
  // group('GetTimeEntryQueryHandler', () {
  //   test('should return a time entry', () async {
  //     final repository = TimeEntryRepositoryMock();
  //     final handler = GetTimeEntryQueryHandler(repository);
  //     final timeEntry = TimeEntry(1, 2, DateTime.now(),
  //         DateTime.now().add(Duration(hours: 2)), 'Worked on project');
  //     await repository.save(timeEntry);
  //     final query = GetTimeEntryQuery(1);
  //     final result = await handler.handle(query);
  //     expect(result, timeEntry);
  //   });
  // });

  // group('UpdateTimeEntryCommandHandler', () {
  //   test('should update a time entry', () async {
  //     final repository = TimeEntryRepositoryMock();
  //     final handler = UpdateTimeEntryCommandHandler(repository);
  //     final timeEntry = TimeEntry(1, 2, DateTime.now(),
  //         DateTime.now().add(Duration(hours: 1)), 'Worked on project X');
  //     await repository.save(timeEntry);
  //     final command = UpdateTimeEntryCommand(
  //         1,
  //         3,
  //         4,
  //         DateTime.now().add(Duration(hours: 2)),
  //         DateTime.now().add(Duration(hours: 3)),
  //         'Worked on project Y');
  //     await handler.handle(command);
  //     final updatedTimeEntry = await repository.findById(1);
  //     expect(updatedTimeEntry.projectId, 3);
  //     expect(updatedTimeEntry.taskId, 4);
  //     expect(
  //         updatedTimeEntry.startTime, DateTime.now().add(Duration(hours: 2)));
  //     expect(updatedTimeEntry.endTime, DateTime.now().add(Duration(hours: 3)));
  //     expect(updatedTimeEntry.description, 'Worked on project Y');
  //   });
  // });

  // group('DeleteTimeEntryCommandHandler', () {
  //   test('should delete a time entry', () async {
  //     final repository = TimeEntryRepositoryMock();
  //     final handler = DeleteTimeEntryCommandHandler(repository);
  //     final timeEntry = TimeEntry(1, 2, DateTime.now(),
  //         DateTime.now().add(Duration(hours: 1)), 'Worked on project X');
  //     await repository.save(timeEntry);
  //     final command = DeleteTimeEntryCommand(1);
  //     await handler.handle(command);
  //     final deletedTimeEntry = await repository.findById(1);
  //     expect(deletedTimeEntry, isNull);
  //   });
  // });
}
