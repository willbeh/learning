// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Watch _$WatchFromJson(Map json) {
  return Watch(
    id: json['id'] as String,
    vid: json['vid'] as String,
    uid: json['uid'] as String,
    data: json['data'] == null ? null : Vimeo.fromJson(json['data'] as Map),
    position: json['position'] as int,
    furthest: json['furthest'] as int,
    status: json['status'] as String,
  );
}

Map<String, dynamic> _$WatchToJson(Watch instance) => <String, dynamic>{
      'id': instance.id,
      'vid': instance.vid,
      'uid': instance.uid,
      'data': instance.data,
      'position': instance.position,
      'furthest': instance.furthest,
      'status': instance.status,
    };
