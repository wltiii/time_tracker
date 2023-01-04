import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

/// Throws: ValueException when the result would mean StartTime would be in an
/// invalid state.
class StartTime extends Equatable {
  StartTime({
    DateTime? dateTime,
  }) {
    final upperBound = DateTime.now();
    final lowerBound = upperBound.subtract(const Duration(days: 7));
    final startTime = dateTime ?? upperBound;

    if (startTime.isAfter(upperBound)) {
      throw ValueException(ExceptionMessage('Start time cannot be after the current time.'));
    }
    if (startTime.isBefore(lowerBound)) {
      throw ValueException(ExceptionMessage('Start time cannot be more than 7 days ago.'));
    }

    _start = startTime;
  }

  /// Creates an instance from an Iso8601 string.
  ///
  /// Throws: FormatException if string is invalid.
  StartTime.fromIso8601String(String iso8601String) : this(dateTime: DateTime.parse(iso8601String));

  late final DateTime _start;

  DateTime get dateTime => _start;
  String get iso8601String => _start.toIso8601String();

  @override
  String toString() => _start.toString();

  //TODO(wltiii): it was necessary to extend Equatable when implementing TimeEntry serialization by hand. Will likely be needed when serialization is done by serializable. Validate.
  @override
  List<Object> get props => [_start];
}

class StartTimeSerializer implements JsonConverter<StartTime, String> {
  const StartTimeSerializer();

  @override
  StartTime fromJson(String json) => StartTime.fromIso8601String(json);

  @override
  String toJson(StartTime dateTime) => dateTime.iso8601String;
}
