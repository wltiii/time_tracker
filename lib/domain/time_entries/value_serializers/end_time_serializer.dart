import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';

class EndTimeSerializer implements JsonConverter<EndTime, String> {
  const EndTimeSerializer();

  @override
  EndTime fromJson(String json) => EndTime.fromIso8601String(json);

  @override
  String toJson(EndTime dateTime) => dateTime.iso8601String;
}
