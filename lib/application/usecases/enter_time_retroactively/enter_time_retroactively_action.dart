import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/repositories/time_entry_repository.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';

//TODO(wltiii): WIP - not handling retroactive updates yet
class EnterTimeRetroactivelyAction {
  EnterTimeRetroactivelyAction(this._repository);

  final TimeEntryRepository _repository;

  Future<Either<Failure, TimeEntry>> call(TimeEntry timeEntry) async {
    // TODO(wltiii): use model rather than command? I don't think that will work
    // TODO(wltiii): as the ID is needed for this action. Does that indicate the
    // TODO(wltiii): entity should be used or a command object?
    // final command = EnterTimeRetroactivelyCommand(timeEntryModel);
    // TODO(wltiii): conflicting information - i see examples where
    // TODO(wltiii): repository calls are made in this layer, and others
    // TODO(wltiii): state that the domain layer has the dependency.
    // TODO(wltiii): I AM CONFUSED
    // final handler = EnterTimeRetroactivelyHandler(_repository);
    // return await handler.handle(command);
    // return await handler.handle(timeEntryModel);

    return await _repository.update(timeEntry);
  }
}
