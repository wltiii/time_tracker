import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/repositories/time_entry_repository.dart';
import 'package:time_tracker/domain/core/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';

/// TODO(wltiii): Not Yet Implemented
class ChangeStartStopTimesAction {
  ChangeStartStopTimesAction(this._repository);

  final TimeEntryRepository _repository;

  Future<Either<Failure, TimeEntry>> call(TimeEntry timeEntry) async {
    //TODO(wltiii): WIP - not handling retroactive updates yet
    return await _repository.update(timeEntry);
  }
}
