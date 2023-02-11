import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker/domain/core/type_defs.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_range.dart';
import 'package:time_tracker/domain/time_entries/value_serializers/end_time_serializer.dart';
import 'package:time_tracker/domain/time_entries/value_serializers/start_time_serializer.dart';
import 'package:time_tracker/domain/time_entries/value_serializers/time_entry_id_serializer.dart';

part 'time_entry.g.dart';

@JsonSerializable()
class TimeEntry extends Equatable {
  //TODO(wltiii): do i want to take a model, all parameters to create a model, or both? Be sure to look at all usages before making a decision!
  TimeEntry({
    required TimeEntryId id,
    required DateTime start,
    required DateTime end,
  })  : _id = id,
        _model = TimeEntryModel(
          startTime: StartTime(dateTime: start),
          endTime: EndTime(dateTime: end),
        );

  const TimeEntry.fromModel({
    required id,
    required model,
  })  : _id = id,
        _model = model;

  factory TimeEntry.fromJson(Json json) => _$TimeEntryFromJson(json);

  Json toJson() => _$TimeEntryToJson(this);

  final TimeEntryId _id;
  final TimeEntryModel _model;

  bool overlapsWith(other) => _model.overlapsWith(other);

  @TimeEntryIdSerializer()
  TimeEntryId get id => _id;
  @StartTimeSerializer()
  StartTime get start => _model.startTime;
  @EndTimeSerializer()
  EndTime get end => _model.endTime;
  TimeEntryRange get timeEntryRange => _model.timeEntryRange;
  bool get isRunning => end.isInfinite;

  @override
  List<Object> get props => [id, start, end];
}
