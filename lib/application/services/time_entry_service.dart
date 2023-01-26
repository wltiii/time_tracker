import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/repositories/time_entry_repository.dart';
import 'package:time_tracker/domain/error/additional_info.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

//TODO(wltiii): WIP
class TimeEntryService {
  TimeEntryService(this._repository);

  final TimeEntryRepository _repository;

  // TODO(wltiii): getAllFor(what exactly?). User, I would think.
  // TODO(wltiii): for the MVP, the invariant should be User,
  // TODO(wltiii): other usecases might consider overlapping entries,
  // TODO(wltiii): enforcing only those that cannot overlap, by the other things tracked (Project, Client, Task, other?)
  Future<Either<Failure, bool>> dateRangeConsistencyValidator(
      TimeEntryModel model) async {
    final result = await _repository.getTimeboxedEntries(
      start: model.start,
      end: model.end,
    );

    Failure? failure;
    var entries = <TimeEntry>[];

    result.fold(
      (l) => failure = l,
      (r) => entries = r,
    );

    if (result.isLeft()) {
      return Either.left(failure!);
    }

    for (final timeEntry in entries) {
      if (model.overlapsWith(timeEntry.timeEntryRange)) {
        return Future.value(
          Left(
            InvalidStateFailure(
                AdditionalInfo('Time entry overlaps with existing entry having '
                    'start ${timeEntry.start.iso8601String} and '
                    'end ${timeEntry.end.iso8601String}.')),
          ),
        );
      }
    }

    return Either.right(true);
  }
}
