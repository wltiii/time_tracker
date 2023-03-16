import 'package:flutter/material.dart';
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
    debugPrint('=== StopTimerAction.call($timeEntryId)');
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

    // final newEndTime = EndTime.now();
    final stoppedEntry = existingEntry.copyWith(end: EndTime.now());

    //TODO(wltiii): Discuss with Manoj - technically if the time is running,
    //TODO(wltiii): there should be no overlapping entries, but it would
    //TODO(wltiii): be technically possible if there is another implementation
    //TODO(wltiii): that does not enforce this invariant. Testing for
    //TODO(wltiii): overlapping entries would provide safety. Do it with the
    //TODO(wltiii): new end time. So, the question is, is this necessary?
    //TODO(wltiii): Probably not on a timer stop.
    // final isOverlapping = await _repository.overlapsWithEntries(
    //   timeEntryRange: stoppedEntry.timeEntryRange,
    // );
    //
    // if (isOverlapping.isLeft()) {
    //   return Left(isOverlapping.left()!);
    // }
    //
    // if (!isOverlapping.right()!) {
    //   return Either.left(
    //     InvalidStateFailure(
    //       AdditionalInfo('Stopping timer overlaps an existing time entry.'),
    //     ),
    //   );
    // }

    // it is valid, persist
    return await _repository.update(stoppedEntry);
  }
}
