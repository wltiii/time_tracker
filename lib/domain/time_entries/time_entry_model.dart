import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker/domain/core/extensions/date_time_range.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_boxed_entries.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_range.dart';
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
    required this.startTime,
    required this.endTime,
  }) {
    if (!(endTime.isAfter(startTime) || endTime.isInfinite)) {
      throw ValueException(
          ExceptionMessage('End time must be after start time.'));
    }
  }

  TimeEntryModel.validatedRunningEntry({
    required TimeBoxedEntries timeBoxedEntries,
  }) : this(
          startTime: timeBoxedEntries.start,
          endTime: timeBoxedEntries.end,
        );

  factory TimeEntryModel.fromJson(Json json) => _$TimeEntryModelFromJson(json);

  Json toJson() => _$TimeEntryModelToJson(this);

  @StartTimeSerializer()
  final StartTime startTime;
  @EndTimeSerializer()
  final EndTime endTime;

  bool overlapsWith(TimeEntryRange other) =>
      timeEntryRange.isOverlapping(other);

  TimeEntryRange get timeEntryRange => TimeEntryRange.fromTimeEntryModel(
        timeEntryModel: this,
      );

  @override
  List<Object> get props => [startTime, endTime];
}
