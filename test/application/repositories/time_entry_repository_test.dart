import 'package:flutter_test/flutter_test.dart';

import '../../infrastructure/repositories/mock_time_entry_repository.dart';

void main() {
  group('CreateTimeEntryCommandHandler', () {
    test('should create a time entry', () async {
      final repository = MockTimeEntryRepository();
      final handler = CreateTimeEntryCommandHandler(repository);
      final command = CreateTimeEntryCommand(
          1, 2, DateTime.now(), DateTime.now().add(Duration(hours: 2)), 'Worked on project');
      await handler.handle(command);
      final timeEntry = await repository.findById(1);
      expect(timeEntry.projectId, 1);
      expect(timeEntry.taskId, 2);
      expect(timeEntry.description, 'Worked on project');
    });
  });

  group('GetTimeEntryQueryHandler', () {
    test('should return a time entry', () async {
      final repository = MockTimeEntryRepository();
      final handler = GetTimeEntryQueryHandler(repository);
      final timeEntry = TimeEntry(
          1, 2, DateTime.now(), DateTime.now().add(Duration(hours: 2)), 'Worked on project');
      await repository.save(timeEntry);
      final query = GetTimeEntryQuery(1);
      final result = await handler.handle(query);
      expect(result, timeEntry);
    });
  });

  group('UpdateTimeEntryCommandHandler', () {
    test('should update a time entry', () async {
      final repository = MockTimeEntryRepository();
      final handler = UpdateTimeEntryCommandHandler(repository);
      final timeEntry = TimeEntry(
          1, 2, DateTime.now(), DateTime.now().add(Duration(hours: 1)), 'Worked on project X');
      await repository.save(timeEntry);
      final command = UpdateTimeEntryCommand(1, 3, 4, DateTime.now().add(Duration(hours: 2)),
          DateTime.now().add(Duration(hours: 3)), 'Worked on project Y');
      await handler.handle(command);
      final updatedTimeEntry = await repository.findById(1);
      expect(updatedTimeEntry.projectId, 3);
      expect(updatedTimeEntry.taskId, 4);
      expect(updatedTimeEntry.startTime, DateTime.now().add(Duration(hours: 2)));
      expect(updatedTimeEntry.endTime, DateTime.now().add(Duration(hours: 3)));
      expect(updatedTimeEntry.description, 'Worked on project Y');
    });
  });

  group('DeleteTimeEntryCommandHandler', () {
    test('should delete a time entry', () async {
      final repository = MockTimeEntryRepository();
      final handler = DeleteTimeEntryCommandHandler(repository);
      final timeEntry = TimeEntry(
          1, 2, DateTime.now(), DateTime.now().add(Duration(hours: 1)), 'Worked on project X');
      await repository.save(timeEntry);
      final command = DeleteTimeEntryCommand(1);
      await handler.handle(command);
      final deletedTimeEntry = await repository.findById(1);
      expect(deletedTimeEntry, isNull);
    });
  });
}
