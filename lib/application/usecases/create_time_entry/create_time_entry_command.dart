import 'package:time_tracker/application/usecases/use_case_command.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

class CreateTimeEntryCommand implements UseCaseCommand<TimeEntry> {
  CreateTimeEntryCommand(
    TimeEntryModel timeEntryModel,
  ) : _timeEntryModel = timeEntryModel;

  final TimeEntryModel _timeEntryModel;

  // TODO(wltiii): add getters
  TimeEntryModel get timeEntryModel => _timeEntryModel;
  // TODO(wltiii): are these convenience getters necessary
  // StartTime get start => _timeEntryModel.start;
  // EndTime get end => _timeEntryModel.end;
  // TimeEntryRange get timeEntryRange => _timeEntryModel.timeEntryRange;
}
