import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/usecases/enter_time_retroactively/enter_time_retroactively_handler.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/infrastructure/repositories/time_entry_repository.dart';

//TODO(wltiii): toying with the idea of an abstract action (usecase?) class using generics
//TODO(wltiii): rather than calling it action, call it usecase?
class EnterTimeRetroactivelyAction /*implements UseCaseAction<TimeEntry>*/ {
  EnterTimeRetroactivelyAction(this._repository);

  final TimeEntryRepository _repository;

  Future<Either<Failure, TimeEntry>> call(TimeEntryModel timeEntryModel) async {
    // TODO(wltiii): use model rather than command? I don't think that will work
    // TODO(wltiii): as the ID is needed for this action. Does that indicate the
    // TODO(wltiii): entity should be used or a command object?
    // final command = EnterTimeRetroactivelyCommand(timeEntryModel);
    // TODO(wltiii): conflicting information - i see examples where
    // TODO(wltiii): repository calls are made in this layer, and others
    // TODO(wltiii): state that the domain layer has the dependency.
    // TODO(wltiii): I AM CONFUSED
    final handler = EnterTimeRetroactivelyHandler(_repository);
    // return await handler.handle(command);
    return await handler.handle(timeEntryModel);
  }
}
