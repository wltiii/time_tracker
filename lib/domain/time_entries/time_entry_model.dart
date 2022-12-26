import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

import '../type_defs.dart';

part 'time_entry_model.g.dart';

/// Freezed is a great package. However, you cannot
/// do constructor validation in order to assure
/// invalid states are unrepresentable.
/// SEE: Discussion with Remi: https://github.com/rrousselGit/freezed/issues/830
@JsonSerializable()
class TimeEntryModel extends Equatable {
  TimeEntryModel({
    required this.start,
    required this.end,
  }) {
    if (!end.isAfter(start)) {
      throw ValueException(ExceptionMessage('End time must be after start time.'));
    }
  }

  final DateTime start;
  final DateTime end;

  @override
  List<Object> get props => [start, end];

  factory TimeEntryModel.fromJson(Json json) => _$TimeEntryModelFromJson(json);

  Json toJson() => _$TimeEntryModelToJson(this);
}
