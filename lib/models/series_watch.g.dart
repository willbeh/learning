// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_watch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesWatch _$SeriesWatchFromJson(Map json) {
  return SeriesWatch(
    id: json['id'] as String,
    sid: json['sid'] as String,
    sdata: json['sdata'] == null ? null : Series.fromJson(json['sdata'] as Map),
    uid: json['uid'] as String,
    date: DateTimeUtil.fromTimestamp(json['date']),
  );
}

Map<String, dynamic> _$SeriesWatchToJson(SeriesWatch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sid': instance.sid,
      'sdata': instance.sdata,
      'uid': instance.uid,
      'date': instance.date?.toIso8601String(),
    };
