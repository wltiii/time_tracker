import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/usecases/start_timer/start_timer_command.dart';
import 'package:time_tracker/application/usecases/start_timer/start_timer_handler.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/infrastructure/repositories/time_entry_repository.dart';

//TODO(wltiii): toying with the idea of an abstract action (usecase?) class using generics
class StartTimerAction /*implements UseCaseAction<TimeEntry>*/ {
  StartTimerAction(this._repository);

  final TimeEntryRepository _repository;

  // TODO(wltiii): should model be used or value objects?
  Future<Either<Failure, TimeEntry>> call(TimeEntryModel timeEntryModel) async {
    final command = StartTimerCommand(timeEntryModel);

    // TODO(wltiii): should entity/model be used or a command object?
    // TODO(wltiii): conflicting information - i see examples where
    // TODO(wltiii): repository calls are made in this layer, and others
    // TODO(wltiii): state that the domain layer has the dependency.
    // TODO(wltiii): I AM CONFUSED
    // TODO(wltiii): since the aggregate has the responsibility for dat
    // TODO(wltiii): the solution is to have that call the repository.
    final handler = StartTimerHandler(_repository);
    return await handler.handle(command);
    // return await handler.handle(timeEntryModel);
  }
}
