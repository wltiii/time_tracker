// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeEntry _$TimeEntryFromJson(Map<String, dynamic> json) => TimeEntry(
      id: const TimeEntryIdSerializer().fromJson(json['id'] as String),
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$TimeEntryToJson(TimeEntry instance) => <String, dynamic>{
      'id': const TimeEntryIdSerializer().toJson(instance.id),
      'start': const StartTimeSerializer().toJson(instance.start),
      'end': const EndTimeSerializer().toJson(instance.end),
    };
