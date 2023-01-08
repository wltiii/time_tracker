import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_serializers/end_time_serializer.dart';
import 'package:time_tracker/domain/time_entries/value_serializers/start_time_serializer.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

import '../core/type_defs.dart';

part 'time_entry_model.g.dart';

/// Freezed is a great package. However, you cannot
/// do constructor validation in order to assure
/// invalid states are unrepresentable.
/// SEE: Discussion with Remi: https://github.com/rrousselGit/freezed/issues/830
@JsonSerializable()
class TimeEntryModel extends Equatable {
  TimeEntryModel({
    required this.start,
    required this.end,
  }) {
    // TODO(wltiii): implement isAfter method allowing it to take a StartTime
    // if (!end.isAfter(start.dateTime)) {
    if (!end.dateTime.isAfter(start.dateTime)) {
      throw ValueException(ExceptionMessage('End time must be after start time.'));
    }
  }

  factory TimeEntryModel.fromJson(Json json) => _$TimeEntryModelFromJson(json);

  Json toJson() => _$TimeEntryModelToJson(this);

  @StartTimeSerializer()
  final StartTime start;
  @EndTimeSerializer()
  final EndTime end;

  @override
  List<Object> get props => [start, end];
}
