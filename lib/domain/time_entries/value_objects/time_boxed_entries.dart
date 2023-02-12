import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';

class TimeBoxedEntries {
  //TODO(wltiii): should use required named parameters
  // TimeBoxedEntries({
  //   required this.start,
  //   required this.end,
  //   required this.timeEntryList,
  // });
  TimeBoxedEntries(
    this.start,
    this.end,
    this.timeEntryList,
  );

  final StartTime start;
  final EndTime end;
  final List<TimeEntry> timeEntryList;

  TimeEntryModel get timeEntryModel =>
      TimeEntryModel(startTime: start, endTime: end);
}
