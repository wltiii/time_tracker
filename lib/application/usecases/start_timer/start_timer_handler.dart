import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/usecases/start_timer/start_timer_command.dart';
import 'package:time_tracker/application/usecases/use_case_handler.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/infrastructure/repositories/time_entry_repository.dart';

class StartTimerHandler
    implements UseCaseHandler<StartTimerCommand, TimeEntry> {
  StartTimerHandler(this._repository);

  final TimeEntryRepository _repository;

  @override
  Future<Either<Failure, TimeEntry>> handle(StartTimerCommand command) async {
    // TODO(wltiii): call add on the entity - not repository
    // TODO(wltiii): or calls should be made from this layer
    // TODO(wltiii): I feel it should call the aggregate entity, which
    // TODO(wltiii): has the responsibility for invariants and other
    // TODO(wltiii): data integrity issues.
    return await _repository.add(command.timeEntryModel);
  }
}
