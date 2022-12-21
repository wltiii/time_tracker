import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

class TimeEntry {
  TimeEntry({
    required this.id,
    required model,
  }) : _model = model;

  final int id;
  final TimeEntryModel _model;

  get start => _model.start;
  get end => _model.end;
}
