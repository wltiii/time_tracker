// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeEntryModel _$TimeEntryModelFromJson(Map<String, dynamic> json) =>
    TimeEntryModel(
      start: const StartTimeSerializer().fromJson(json['start'] as String),
      end: const EndTimeSerializer().fromJson(json['end'] as String),
    );

Map<String, dynamic> _$TimeEntryModelToJson(TimeEntryModel instance) =>
    <String, dynamic>{
      'start': const StartTimeSerializer().toJson(instance.start),
      'end': const EndTimeSerializer().toJson(instance.end),
    };
