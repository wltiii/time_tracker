import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/repositories/time_entry_repository.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

//TODO(wltiii): WIP
class TimeEntryService {
  final TimeEntryRepository _repository;
  TimeEntryService(this._repository);
  Future<Either<Failure, TimeEntry>> createTimeEntry(TimeEntryModel model) async {
    final existingTimeEntries = await _repository.getAllForTask(model.taskId);
    // final newTimeEntry = TimeEntry(model);
    final newTimeEntry = TimeEntry(
      start: model.start.dateTime,
      end: model.end.dateTime,
    );
    for (final timeEntry in existingTimeEntries) {
      newTimeEntry.overlapsWith(timeEntry);
    }
    return await _repository.add(newTimeEntry);
  }
}
