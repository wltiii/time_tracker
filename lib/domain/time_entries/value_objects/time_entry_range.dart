import 'package:flutter/material.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';

@immutable
class TimeEntryRange extends DateTimeRange {
  TimeEntryRange({
    required this.startTime,
    required this.endTime,
  }) : super(
          start: startTime.dateTime,
          end: endTime.dateTime,
        );

  /// The start of the range of dates.
  // final StartTime startTime;
  // StartTime get startTime => StartTime(dateTime: super.start);
  final StartTime startTime;

  /// The end of the range of dates.
  // EndTime get endTime => EndTime(dateTime: super.start);
  final endTime;
}
