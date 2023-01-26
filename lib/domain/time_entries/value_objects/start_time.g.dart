// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'start_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartTime _$StartTimeFromJson(Map<String, dynamic> json) => StartTime(
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$StartTimeToJson(StartTime instance) => <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
    };
