import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';

class TimeBoxedEntries {
  TimeBoxedEntries({
    required StartTime start,
    required EndTime end,
    required this.timeEntryList,
  }) {
    timeEntryModel = TimeEntryModel(startTime: start, endTime: end);
  }

  late TimeEntryModel timeEntryModel;
  final List<TimeEntry> timeEntryList;

  StartTime get start => timeEntryModel.startTime;
  EndTime get end => timeEntryModel.endTime;
}
