import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';

@immutable
class TimeEntryRange extends DateTimeRange {
  //TODO(wltiii): this allows an invalid state to be constructed. Verify that end is after start
  TimeEntryRange({
    required this.startTime,
    required this.endTime,
  }) : super(
          start: startTime.dateTime,
          end: endTime.dateTime,
        );

  /// Creates from [TimeEntryModel] which enforces state/end time invariants
  TimeEntryRange.fromTimeEntryModel({
    required TimeEntryModel timeEntryModel,
  }) : this(
          startTime: timeEntryModel.start,
          endTime: timeEntryModel.end,
        );

  /// The start of the range of dates.
  final StartTime startTime;

  /// The end of the range of dates.
  final EndTime endTime;

  Timestamp get startTimestamp => Timestamp.fromDate(startTime.dateTime);
  Timestamp get endTimestamp => Timestamp.fromDate(endTime.dateTime);
}
