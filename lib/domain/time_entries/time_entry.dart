import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

class TimeEntry {
  TimeEntry({
    required this.id,
    required this.model,
  });

  final int id;
  final TimeEntryModel model;
}
