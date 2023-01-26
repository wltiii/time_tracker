import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
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
    DateTime? dateTime,
  }) {
    final upperBound = DateTime.now();
    final lowerBound = upperBound.subtract(const Duration(days: 7));

    if (dateTime == _infiniteTime) {
      _value = _infiniteTime;
      return;
    } else if (dateTime == null) {
      _value = _infiniteTime;
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

  /// Creates an instance from an Iso8601 string.
  ///
  /// Throws: FormatException if string is invalid.
  EndTime.fromIso8601String(String iso8601String)
      : this(dateTime: DateTime.parse(iso8601String));

  late final DateTime _value;
  final DateTime _infiniteTime = DateTime.utc(275760, 09, 13);

  DateTime get dateTime => _value;
  String get iso8601String => _value.toIso8601String();
  bool get isInfinite => _value == _infiniteTime;

  @override
  String toString() => _value.toString();

  //TODO(wltiii): it was necessary to extend Equatable when implementing TimeEntry serialization by hand. Will likely be needed when serialization is done by serializable. Validate.
  @override
  List<Object> get props => [_value];
}
