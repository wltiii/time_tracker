// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeEntryModel _$TimeEntryModelFromJson(Map<String, dynamic> json) =>
    TimeEntryModel(
      startTime:
          const StartTimeSerializer().fromJson(json['startTime'] as String),
      endTime: const EndTimeSerializer().fromJson(json['endTime'] as String),
    );

Map<String, dynamic> _$TimeEntryModelToJson(TimeEntryModel instance) =>
    <String, dynamic>{
      'startTime': const StartTimeSerializer().toJson(instance.startTime),
      'endTime': const EndTimeSerializer().toJson(instance.endTime),
    };
