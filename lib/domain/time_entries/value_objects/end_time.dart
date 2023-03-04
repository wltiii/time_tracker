import 'package:cloud_firestore/cloud_firestore.dart';
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
    final currentDateTime = DateTime.now();

    if (dateTime == DateTimeHelper.firestoreMaxDate()) {
      _value = dateTime;
      return;
    }

    if (dateTime.isAfter(currentDateTime)) {
      throw ValueException(
          ExceptionMessage('End time cannot be after the current time.'));
    }

    if (dateTime.isAfter(DateTimeHelper.firestoreMaxDate())) {
      throw ValueException(ExceptionMessage(
          //TODO(wltiii): this message is wrong
          'End time cannot be after the 9999-12-31T23:59:59.999999999.'));
    }

    _value = dateTime;
  }

  /// Creates an instance as current DateTime.
  EndTime.now() : this(dateTime: DateTime.now());

  /// Creates an instance equal to the end of time
  // EndTime.endOfTime() : this(dateTime: DateTimeHelper.endOfTime());
  /// Creates an instance equal to the maximum allowed Firestore timestamp
  EndTime.endOfTime() : this(dateTime: DateTimeHelper.firestoreMaxDate());

  /// Creates an instance from an Iso8601 string.
  ///
  /// Throws: FormatException if string is invalid.
  EndTime.fromIso8601String(String iso8601String)
      : this(dateTime: DateTime.parse(iso8601String));

  late final DateTime _value;

  bool isAfter(StartTime startTime) => dateTime.isAfter(startTime.dateTime);

  /// difference(StartTime startTime)
  /// calculates the duration from the given start time
  Duration difference(StartTime startTime) =>
      dateTime.difference(startTime.dateTime);
  DateTime get dateTime => _value;
  String get iso8601String => _value.toIso8601String();
  Timestamp get endTimestamp => Timestamp.fromDate(dateTime);
  bool get isInfinite =>
      _value == DateTimeHelper.firestoreMaxDate() ||
      _value.isAfter(DateTimeHelper.firestoreMaxDate());

  @override
  String toString() => _value.toString();

  @override
  List<Object> get props => [_value];
}
