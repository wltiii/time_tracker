import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

part 'start_time.g.dart';

/// Throws: ValueException when the result would mean StartTime would be in an
/// invalid state.
@JsonSerializable()
@immutable
class StartTime extends Equatable {
  StartTime({
    DateTime? startTime,
  }) {
    final currentDateTime = DateTime.now();
    // final sevenDaysPastTense = currentDateTime.subtract(const Duration(days: 7));
    final start = startTime ?? currentDateTime;

    if (start.isAfter(currentDateTime)) {
      throw ValueException(
          ExceptionMessage('Start time cannot be after the current time.'));
    }

    _value = start;
  }

  /// Creates an instance from an Iso8601 string.
  ///
  /// Throws: FormatException if string is invalid.
  StartTime.fromIso8601String(String iso8601String)
      : this(startTime: DateTime.parse(iso8601String));

  late final DateTime _value;

  DateTime get dateTime => _value;
  String get iso8601String => _value.toIso8601String();

  @override
  String toString() => _value.toString();

  //TODO(wltiii): it was necessary to extend Equatable when implementing TimeEntry serialization by hand. Will likely be needed when serialization is done by serializable. Validate.
  @override
  List<Object> get props => [_value];
}
