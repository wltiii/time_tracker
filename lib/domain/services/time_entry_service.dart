import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/error/additional_info.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/infrastructure/repositories/time_entry_repository.dart';

//TODO(wltiii): WIP
class TimeEntryService {
  TimeEntryService(this._repository);

  final TimeEntryRepository _repository;

  // TODO(wltiii): getTimeboxedEntries(what exactly?). User, I would think.
  // TODO(wltiii): for the MVP, the invariant should be User,
  // TODO(wltiii): other usecases might consider overlapping entries,
  // TODO(wltiii): enforcing only those that cannot overlap, by the other
  // TODO(wltiii): things tracked (Project, Client, Task, other?)
  // TODO(wltiii): it seems validation should be done in the entity
  Future<Either<Failure, bool>> dateRangeConsistencyValidator(
      TimeEntryModel model) async {
    final result = await _repository.getTimeboxedEntries(
      start: model.start,
      end: model.end,
    );

    return result.fold(
      (l) {
        return Either.left(l);
      },
      (entries) {
        return Future.value(
          _timeRangeOverlapsWithExistingTimeEntry(
            model,
            entries,
          ),
        );
      },
    );
  }

  Either<Failure, bool> _timeRangeOverlapsWithExistingTimeEntry(
      TimeEntryModel model, List<TimeEntry> entries) {
    for (final timeEntry in entries) {
      if (model.overlapsWith(timeEntry.timeEntryRange)) {
        return Either.left(
          InvalidStateFailure(
              AdditionalInfo('Time entry overlaps with existing entry having '
                  'start ${timeEntry.start.iso8601String} and '
                  'end ${timeEntry.end.iso8601String}.')),
        );
      }
    }

    return Either.right(false);
  }
}
