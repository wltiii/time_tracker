import 'package:time_tracker/application/usecases/use_case_command.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';

class EnterTimeRetroactivelyCommand implements UseCaseCommand<TimeEntry> {
  EnterTimeRetroactivelyCommand(
    this.id,
    this.timeEntryModel,
  );

  final TimeEntryId id;
  final TimeEntryModel timeEntryModel;
}
