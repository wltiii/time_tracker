import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/repositories/time_entry_repository.dart';
import 'package:time_tracker/application/usecases/enter_time_retroactively/enter_time_retroactively_command.dart';
import 'package:time_tracker/application/usecases/use_case_handler.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';

class EnterTimeRetroactivelyHandler
    implements UseCaseHandler<EnterTimeRetroactivelyCommand, TimeEntry> {
  EnterTimeRetroactivelyHandler(this._repository);

  final TimeEntryRepository _repository;

  @override
  Future<Either<Failure, TimeEntry>> handle(EnterTimeRetroactivelyCommand command) async {
    //TODO(wltiii): two options for creating TimeEntry (as I have developed at present). All parameters to create a model, or both? Not sure I like either option
    //TODO(wltiii): another option would be to eliminate the Command object altogether and take the model. What are the consequences of this?
    final timeEntry = TimeEntry(
      id: command.id,
      start: command.timeEntryModel.start.dateTime,
      end: command.timeEntryModel.end.dateTime,
    );
    // final timeEntry = TimeEntry(
    //   id: null,
    //   model: command.timeEntryModel,
    //   // command.timeEntryModel.projectId,
    //   // command.timeEntryModel.taskId,
    //   // command.timeEntryModel.startTime,
    //   // command.timeEntryModel.endTime,
    //   // command.timeEntryModel.description,
    // );

    return await _repository.update(timeEntry);
  }
}
