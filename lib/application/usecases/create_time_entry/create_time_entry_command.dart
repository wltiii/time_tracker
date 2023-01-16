import 'package:time_tracker/application/usecases/use_case_command.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_range.dart';

class CreateTimeEntryCommand implements UseCaseCommand<TimeEntry> {
  CreateTimeEntryCommand(
    TimeEntryModel timeEntryModel,
  ) : _timeEntryModel = timeEntryModel;

  final TimeEntryModel _timeEntryModel;

  // TODO(wltiii): add getters
  TimeEntryModel get timeEntryModel => _timeEntryModel;
  StartTime get start => _timeEntryModel.start;
  EndTime get end => _timeEntryModel.end;
  TimeEntryRange get timeEntryRange => _timeEntryModel.timeEntryRange;
}
