import 'package:json_annotation/json_annotation.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

@JsonSerializable()
class TimeEntryId extends Id {
  TimeEntryId(String value) : super(value);

  // TimeEntryId get id => this;
}
