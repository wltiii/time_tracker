import 'package:flutter/material.dart';
import 'package:time_tracker/domain/core/extensions/date_time.dart';

extension OverlappingRange on DateTimeRange {
  /// Validates that this DateTimeRange instance is within the range, inclusive.
  /// Returns [bool] true when it is within the range inclusive, false otherwise.
  bool isOverlapping(DateTimeRange other) {
    if (start.inRange(other)) {
      return true;
    }
    if (end.inRange(other)) {
      return true;
    }
    if (other.start.inRange(this)) {
      return true;
    }
    if (other.end.inRange(this)) {
      return true;
    }
    return false;
  }
}
