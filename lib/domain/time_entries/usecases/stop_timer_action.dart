import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';
import 'package:time_tracker/domain/usecases/use_case_action.dart';

abstract class StopTimerUseCaseAction<TimeEntry> extends UseCaseAction {
  Future<Either<Failure, TimeEntry>> call(TimeEntryId timeEntryId);
}
