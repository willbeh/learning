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
    created: DateTimeUtil.fromTimestamp(json['created']),
    completed: DateTimeUtil.fromTimestamp(json['completed']),
    status: json['status'] as String,
    test: json['test'] as bool,
    enableTest: json['enable_test'] as bool,
  );
}

Map<String, dynamic> _$SeriesWatchToJson(SeriesWatch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sid': instance.sid,
      'sdata': Series.utilToJson(instance.sdata),
      'uid': instance.uid,
      'date': instance.date?.toIso8601String(),
      'created': instance.created?.toIso8601String(),
      'completed': instance.completed?.toIso8601String(),
      'status': instance.status,
      'test': instance.test,
      'enable_test': instance.enableTest,
    };
