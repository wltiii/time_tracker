import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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
@immutable
class TimeEntry extends Equatable {
  TimeEntry({
    required TimeEntryId id,
    required DateTime start,
    required DateTime end,
  })  : _id = id,
        _model = TimeEntryModel(
          start: StartTime(startTime: start),
          end: EndTime(dateTime: end),
        );

  const TimeEntry.fromModel({
    required TimeEntryId id,
    required TimeEntryModel model,
  })  : _id = id,
        _model = model;

  factory TimeEntry.fromJson(Json json) => _$TimeEntryFromJson(json);

  Json toJson() => _$TimeEntryToJson(this);

  final TimeEntryId _id;
  final TimeEntryModel _model;

  @TimeEntryIdSerializer()
  TimeEntryId get id => _id;
  @StartTimeSerializer()
  StartTime get start => _model.start;
  @EndTimeSerializer()
  EndTime get end => _model.end;
  TimeEntryRange get timeEntryRange => _model.timeEntryRange;
  bool get isRunning => end.isInfinite;
  String get value => _id.id;

  bool overlapsWith(other) => _model.overlapsWith(other);

  TimeEntry copyWith({
    StartTime? start,
    EndTime? end,
  }) {
    return TimeEntry(
      id: id,
      start: start == null ? this.start.dateTime : start.dateTime,
      end: end == null ? this.end.dateTime : end.dateTime,
    );
  }

  @override
  List<Object> get props => [id, start, end];
}
