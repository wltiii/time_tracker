import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';

class TimeEntryIdSerializer implements JsonConverter<TimeEntryId, String> {
  const TimeEntryIdSerializer();

  @override
  TimeEntryId fromJson(String json) => TimeEntryId(json);

  @override
  String toJson(TimeEntryId id) => id.value;
}
