import 'package:equatable/equatable.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

/// Throws: ValueException when the result would mean EndTime would be in an
/// invalid state.
class EndTime extends Equatable {
  EndTime({
    DateTime? dateTime,
  }) {
    final upperBound = DateTime.now();
    final lowerBound = upperBound.subtract(const Duration(days: 7));
    final endTime = dateTime ?? upperBound;

    if (endTime.isAfter(upperBound)) {
      throw ValueException(ExceptionMessage('End time cannot be after the current time.'));
    }
    if (endTime.isBefore(lowerBound)) {
      throw ValueException(ExceptionMessage('End time cannot be more than 7 days ago.'));
    }

    _value = endTime;
  }

  /// Creates an instance from an Iso8601 string.
  ///
  /// Throws: FormatException if string is invalid.
  EndTime.fromIso8601String(String iso8601String) : this(dateTime: DateTime.parse(iso8601String));

  late final DateTime _value;

  DateTime get dateTime => _value;
  String get iso8601String => _value.toIso8601String();

  @override
  String toString() => _value.toString();

  //TODO(wltiii): it was necessary to extend Equatable when implementing TimeEntry serialization by hand. Will likely be needed when serialization is done by serializable. Validate.
  @override
  List<Object> get props => [_value];
}