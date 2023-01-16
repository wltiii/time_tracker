import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/repositories/time_entry_repository.dart';
import 'package:time_tracker/application/usecases/create_time_entry/create_time_entry_command.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';

class CreateTimeEntryHandler
// implements UseCaseHandler<EnterTimeRetroactivelyCommand, TimeEntry> {
/*implements
        UseCaseHandler<TimeEntryModel, TimeEntry>*/
{
  CreateTimeEntryHandler(this._repository);

  final TimeEntryRepository _repository;

  @override
  // Future<Either<Failure, TimeEntry>> handle(EnterTimeRetroactivelyCommand command) async {
  Future<Either<Failure, TimeEntry>> handle(
      CreateTimeEntryCommand command) async {
    // TODO(wltiii): call add on the entity - no repository
    // TODO(wltiii): or calls should be made from this layer
    return await _repository.add(command.timeEntryModel);
  }
}
