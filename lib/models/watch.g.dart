// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Watch _$WatchFromJson(Map<String, dynamic> json) {
  return Watch(
    id: json['id'] as String,
    vid: json['vid'] as String,
    vname: json['vname'] as String,
    vpicture: json['vpicture'] as String,
    vduration: json['vduration'] as int,
    uid: json['uid'] as String,
    position: json['position'] as int,
    furthest: json['furthest'] as int,
    status: json['status'] as String,
    date: DateTimeUtil.fromTimestamp(json['date']),
    created: DateTimeUtil.fromTimestamp(json['created']),
    sid: json['sid'] as String,
  );
}

Map<String, dynamic> _$WatchToJson(Watch instance) => <String, dynamic>{
      'id': instance.id,
      'vid': instance.vid,
      'vname': instance.vname,
      'vpicture': instance.vpicture,
      'vduration': instance.vduration,
      'uid': instance.uid,
      'position': instance.position,
      'furthest': instance.furthest,
      'status': instance.status,
      'date': instance.date?.toIso8601String(),
      'created': instance.created?.toIso8601String(),
      'sid': instance.sid,
    };
