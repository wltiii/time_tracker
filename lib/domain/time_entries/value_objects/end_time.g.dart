// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'end_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EndTime _$EndTimeFromJson(Map<String, dynamic> json) => EndTime(
      dateTime: DateTime.parse(json['dateTime'] as String),
    );

Map<String, dynamic> _$EndTimeToJson(EndTime instance) => <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
    };
