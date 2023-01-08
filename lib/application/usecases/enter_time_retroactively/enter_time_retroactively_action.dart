import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/repositories/time_entry_repository.dart';
import 'package:time_tracker/application/usecases/enter_time_retroactively/enter_time_retroactively_command.dart';
import 'package:time_tracker/application/usecases/enter_time_retroactively/enter_time_retroactively_handler.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

//TODO(wltiii): toying with the idea of an abstract action (usecase?) class using generics
class EnterTimeRetroactivelyAction /*implements UseCaseAction<TimeEntry>*/ {
  EnterTimeRetroactivelyAction(this._repository);

  final TimeEntryRepository _repository;

  Future<Either<Failure, TimeEntry>> call(TimeEntryModel timeEntryModel) async {
    final command = EnterTimeRetroactivelyCommand(timeEntryModel);
    final handler = EnterTimeRetroactivelyHandler(_repository);
    return await handler.handle(command);
  }
}
