import 'package:flutter/material.dart';
import 'package:time_tracker/domain/core/extensions/date_time.dart';

extension OverlappingRange on DateTimeRange {
  /// Validates that this DateTimeRange instance is within the range, inclusive.
  /// Returns [bool] true when it is within the range inclusive, false otherwise.
  bool overlapsWith(DateTimeRange other) {
    if (start.inRange(other) || end.inRange(other)) {
      return true;
    }
    return false;
  }
}
