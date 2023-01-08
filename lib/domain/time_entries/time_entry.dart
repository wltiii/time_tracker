import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker/domain/core/type_defs.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';
import 'package:time_tracker/domain/time_entries/value_serializers/time_entry_id_serializer.dart';

part 'time_entry.g.dart';

//TODO(wltiii): The idea is to make this an abstract class
//TODO(wltiii): If the above is done, method overlapsWith will have to be abstract
//TODO(wltiii): If the above is done, it might be nice to have a convenience method that reveals the concrete implementation type...
@JsonSerializable()
class TimeEntry {
  //TODO(wltiii): do i want to take a model, all parameters to create a model, or both? Be sure to look at all usages before making a decision!
  TimeEntry({
    required id,
    required DateTime start,
    required DateTime end,
  })  : _id = id,
        _model = TimeEntryModel(start: StartTime(dateTime: start), end: EndTime(dateTime: end));

  // TimeEntry({
  //   required id,
  //   required model,
  // })  : _id = id,
  //       _model = model;

  factory TimeEntry.fromJson(Json json) => _$TimeEntryFromJson(json);

  Json toJson() => _$TimeEntryToJson(this);

  void overlapsWith(TimeEntry other) {
    if (start.isBefore(other.end) && end.isAfter(other.start)) {
      throw ArgumentError('Time entries cannot overlap');
    }
  }

  //TODO(wltiii): create and use TimeEntryId from Id in package unrepresentable_state/unrepresentable_state.dart
  @TimeEntryIdSerializer()
  final TimeEntryId _id;
  final TimeEntryModel _model;

  get id => _id.value;
  get start => _model.start;
  get end => _model.end;
}
