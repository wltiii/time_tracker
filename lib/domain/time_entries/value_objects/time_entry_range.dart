import 'package:flutter/material.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';

@immutable
class TimeEntryRange extends DateTimeRange {
  TimeEntryRange._({
    required this.startTime,
    required this.endTime,
  }) : super(
          start: startTime.dateTime,
          end: endTime.dateTime,
        );

  /// Creates from [TimeEntryModel] which enforces state/end time invariants
  TimeEntryRange.fromTimeEntryModel({
    required TimeEntryModel timeEntryModel,
  }) : this._(
          startTime: timeEntryModel.startTime,
          endTime: timeEntryModel.endTime,
        );

  /// The start of the range of dates.
  // final StartTime startTime;
  // StartTime get startTime => StartTime(dateTime: super.start);
  final StartTime startTime;

  /// The end of the range of dates.
  // EndTime get endTime => EndTime(dateTime: super.start);
  final EndTime endTime;
}
