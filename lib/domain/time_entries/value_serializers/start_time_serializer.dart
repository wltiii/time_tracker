import 'package:json_annotation/json_annotation.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';

class StartTimeSerializer implements JsonConverter<StartTime, String> {
  const StartTimeSerializer();

  @override
  StartTime fromJson(String json) => StartTime.fromIso8601String(json);

  @override
  String toJson(StartTime dateTime) => dateTime.iso8601String;
}
