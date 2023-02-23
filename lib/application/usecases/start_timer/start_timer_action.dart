import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/repositories/time_entry_repository.dart';
import 'package:time_tracker/domain/core/extensions/either.dart';
import 'package:time_tracker/domain/error/additional_info.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/usecases/start_timer_action.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_range.dart';

class StartTimerAction implements StartTimerUseCaseAction {
  StartTimerAction(this._repository);

  final TimeEntryRepository _repository;

  @override
  Future<Either<Failure, TimeEntry>> call() async {
    final startTime = StartTime();
    final endOfTime = EndTime.endOfTime();

    final overlapsWithEntries = await _repository.overlapsWithEntries(
      timeEntryRange: TimeEntryRange(
        startTime: startTime,
        endTime: endOfTime,
      ),
    );

    if (overlapsWithEntries.isLeft()) {
      return Left(overlapsWithEntries.left()!);
    }

    if (overlapsWithEntries.right()!) {
      return Either.left(
        InvalidStateFailure(
          AdditionalInfo('Time entry overlaps with an existing time entry.'),
        ),
      );
    }

    // it is valid, persist
    return await _repository.add(
      TimeEntryModel(
        startTime: startTime,
        endTime: endOfTime,
      ),
    );
  }
}
