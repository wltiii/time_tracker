import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/core/extensions/either.dart';
import 'package:time_tracker/domain/error/additional_info.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/repositories/time_entry_repository.dart';
import 'package:time_tracker/domain/services/time_entry_validation_service.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';

class StartTimerAction {
  StartTimerAction(this._repository);

  final TimeEntryRepository _repository;

  Future<Either<Failure, TimeEntry>> call() async {
    final startTime = StartTime();
    final endOfTime = EndTime.endOfTime();

    final timeBoxedEntries = await _repository.getTimeBoxedEntriesForModel(
      timeEntryModel: TimeEntryModel(
        startTime: startTime,
        endTime: endOfTime,
      ),
    );

    if (timeBoxedEntries.isLeft()) {
      return Either.left(timeBoxedEntries.left()!);
    }

    final isValid = TimeEntryValidationService().dateTimeRangeIsConsistent(
      modelToValidate: timeBoxedEntries.right()!.timeEntryModel,
      existingEntries: timeBoxedEntries.right()!.timeEntryList,
    );

    if (!isValid) {
      return Either.left(
        InvalidStateFailure(
          AdditionalInfo('Time entry overlaps with an existing time entry.'),
        ),
      );
    }

    // it is valid, persist
    return await _repository.add(timeBoxedEntries.right()!.timeEntryModel);
  }
}
