import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/repositories/time_entry_repository.dart';
import 'package:time_tracker/application/usecases/create_time_entry/create_time_entry_command.dart';
import 'package:time_tracker/application/usecases/create_time_entry/create_time_entry_handler.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

//TODO(wltiii): toying with the idea of an abstract action (usecase?) class using generics
class CreateTimeEntryAction /*implements UseCaseAction<TimeEntry>*/ {
  CreateTimeEntryAction(this._repository);

  final TimeEntryRepository _repository;

  Future<Either<Failure, TimeEntry>> call(TimeEntryModel timeEntryModel) async {
    // TODO(wltiii): should entity/model be used or a command object?
    final command = CreateTimeEntryCommand(timeEntryModel);
    // TODO(wltiii): conflicting information - i see examples where
    // TODO(wltiii): repository calls are made in this layer, and others
    // TODO(wltiii): state that the domain layer has the dependency.
    // TODO(wltiii): I AM CONFUSED
    final handler = CreateTimeEntryHandler(_repository);
    return await handler.handle(command);
    // return await handler.handle(timeEntryModel);
  }
}
