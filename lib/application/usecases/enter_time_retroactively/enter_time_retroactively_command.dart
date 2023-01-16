import 'package:time_tracker/application/usecases/use_case_command.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';

class EnterTimeRetroactivelyCommand implements UseCaseCommand<TimeEntry> {
  EnterTimeRetroactivelyCommand(
    TimeEntry timeEntry,
  ) : _timeEntry = timeEntry;

  final TimeEntry _timeEntry;

  // TODO(wltiii): add getters
}
