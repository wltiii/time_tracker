import 'package:equatable/equatable.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

import '../type_defs.dart';

// part 'time_entry_model.g.dart';

/// Freezed is a great package. However, you cannot
/// do constructor validation in order to assure
/// invalid states are unrepresentable.
/// SEE: Discussion with Remi: https://github.com/rrousselGit/freezed/issues/830
// @JsonSerializable()
class TimeEntryModel extends Equatable {
  TimeEntryModel({
    required this.start,
    required this.end,
  }) {
    // TODO(wltiii): implement isAfter method allowing it to take a StartTime
    if (!end.isAfter(start.dateTime)) {
      throw ValueException(ExceptionMessage('End time must be after start time.'));
    }
  }

  //TODO(wltiii): do not hand code this method
  // factory TimeEntryModel.fromJson(Json json) => _$TimeEntryModelFromJson(json);
  factory TimeEntryModel.fromJson(Json json) => TimeEntryModel(
        start: StartTime.fromIso8601String(json['start']),
        end: DateTime.parse(json['end']),
      );

  //TODO(wltiii): do not hand code this method
  // Json toJson() => _$TimeEntryModelToJson(this);
  Json toJson() => {
        'start': start.iso8601String,
        'end': end.toIso8601String(),
      };

  final StartTime start;
  final DateTime end;

  @override
  List<Object> get props => [start, end];
}
