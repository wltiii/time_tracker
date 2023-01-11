import 'package:flutter/material.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';

import 'end_time.dart';

class TimeEntryRange extends DateTimeRange {
  TimeEntryRange({
    required StartTime start,
    required EndTime end,
  }) : super(
          start: start.dateTime,
          end: end.dateTime,
        );
}
