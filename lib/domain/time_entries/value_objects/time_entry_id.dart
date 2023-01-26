import 'package:json_annotation/json_annotation.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

part 'time_entry_id.g.dart';

@JsonSerializable()
class TimeEntryId extends Id {
  TimeEntryId(String value) : super(value);

  @override
  String toString() => value.toString();

  @override
  List<Object> get props => [id];

  String get id => value;
}
