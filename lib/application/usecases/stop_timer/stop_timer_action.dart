import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/repositories/time_entry_repository.dart';
import 'package:time_tracker/domain/core/extensions/either.dart';
import 'package:time_tracker/domain/error/additional_info.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/usecases/stop_timer_action.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';

class StopTimerAction implements StopTimerUseCaseAction {
  StopTimerAction(this._repository);

  final TimeEntryRepository _repository;

  @override
  Future<Either<Failure, TimeEntry>> call(TimeEntryId timeEntryId) async {
    final eitherExistingEntry = await _repository.get(timeEntryId);
    if (eitherExistingEntry.isLeft()) {
      return Left(eitherExistingEntry.left()!);
    }

    final existingEntry = eitherExistingEntry.right()!;

    if (!existingEntry.end.isInfinite) {
      return Either.left(
        InvalidStateFailure(
          AdditionalInfo('Cannot stop a timer that is already stopped.'),
        ),
      );
    }

    final newEndTime = EndTime.now();

    //TODO(wltiii): Discuss with Manoj - technically if the time was started, there should be no overlapping entries, but it would provide safety. Do it with the new end time.
    // it is valid, persist
    return await _repository.update(existingEntry.copyWith(end: newEndTime));
  }
}
