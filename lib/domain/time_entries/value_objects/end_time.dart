import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker/domain/core/helpers/date_time_helper.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

part 'end_time.g.dart';

/// Represents the end time of a [TimeEntry]. The default is an "infinite",
/// which is the maximum value that can be represented by [DateTime].
///
/// Throws [ValueException] when the dateTime passed is more than seven days
/// in the past or if it is greater than the current time.
@JsonSerializable()
class EndTime extends Equatable {
  EndTime({
    required DateTime dateTime,
  }) {
    final upperBound = DateTime.now();
    final lowerBound = upperBound.subtract(const Duration(days: 7));

    if (dateTime == DateTimeHelper.endOfTime()) {
      _value = dateTime;
      return;
    }

    if (dateTime.isAfter(upperBound)) {
      throw ValueException(
          ExceptionMessage('End time cannot be after the current time.'));
    }
    if (dateTime.isBefore(lowerBound)) {
      throw ValueException(
          ExceptionMessage('End time cannot be more than 7 days ago.'));
    }

    _value = dateTime;
  }

  /// Creates an instance as current DateTime.
  EndTime.now() : this(dateTime: DateTime.now());

  /// Creates an instance equal to the end of time
  EndTime.endOfTime() : this(dateTime: DateTimeHelper.endOfTime());

  /// Creates an instance from an Iso8601 string.
  ///
  /// Throws: FormatException if string is invalid.
  EndTime.fromIso8601String(String iso8601String)
      : this(dateTime: DateTime.parse(iso8601String));

  late final DateTime _value;

  bool isAfter(StartTime startTime) => dateTime.isAfter(startTime.dateTime);
  DateTime get dateTime => _value;
  String get iso8601String => _value.toIso8601String();
  bool get isInfinite => _value == DateTimeHelper.endOfTime();

  @override
  String toString() => _value.toString();

  @override
  List<Object> get props => [_value];
}
