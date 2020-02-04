// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VimeoSize _$VimeoSizeFromJson(Map json) {
  return VimeoSize(
    json['width'] as int,
    json['height'] as int,
    json['link'] as String,
  );
}

Map<String, dynamic> _$VimeoSizeToJson(VimeoSize instance) => <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'link': instance.link,
    };

VimeoFile _$VimeoFileFromJson(Map json) {
  return VimeoFile(
    json['quality'] as String,
    json['type'] as String,
    json['link'] as String,
    json['width'] as int,
    json['height'] as int,
  );
}

Map<String, dynamic> _$VimeoFileToJson(VimeoFile instance) => <String, dynamic>{
      'quality': instance.quality,
      'type': instance.type,
      'link': instance.link,
      'width': instance.width,
      'height': instance.height,
    };

VimeoPicture _$VimeoPictureFromJson(Map json) {
  return VimeoPicture(
    json['uri'] as String,
    (json['sizes'] as List)
        ?.map((e) => e == null ? null : VimeoSize.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$VimeoPictureToJson(VimeoPicture instance) =>
    <String, dynamic>{
      'uri': instance.uri,
      'sizes': VimeoSize.utilToJson(instance.sizes),
    };

VimeoUser _$VimeoUserFromJson(Map json) {
  return VimeoUser(
    json['uri'] as String,
    json['name'] as String,
    json['pictures'] == null
        ? null
        : VimeoPicture.fromJson(json['pictures'] as Map),
  );
}

Map<String, dynamic> _$VimeoUserToJson(VimeoUser instance) => <String, dynamic>{
      'uri': instance.uri,
      'name': instance.name,
      'pictures': VimeoPicture.utilToJson(instance.pictures),
    };

Vimeo _$VimeoFromJson(Map json) {
  return Vimeo(
    name: json['name'] as String,
    description: json['description'] as String,
    link: json['link'] as String,
    duration: json['duration'] as int,
    pictures: json['pictures'] == null
        ? null
        : VimeoPicture.fromJson(json['pictures'] as Map),
    user: json['user'] == null ? null : VimeoUser.fromJson(json['user'] as Map),
    files: (json['files'] as List)
        ?.map((e) => e == null ? null : VimeoFile.fromJson(e as Map))
        ?.toList(),
    width: json['width'] as int,
    height: json['height'] as int,
  );
}

Map<String, dynamic> _$VimeoToJson(Vimeo instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'link': instance.link,
      'duration': instance.duration,
      'pictures': VimeoPicture.utilToJson(instance.pictures),
      'user': instance.user,
      'files': VimeoFile.utilToJson(instance.files),
      'width': instance.width,
      'height': instance.height,
    };

Video _$VideoFromJson(Map json) {
  return Video(
    id: json['id'] as String,
    sid: json['sid'] as String,
    vid: json['vid'] as String,
    status: json['status'] as String,
    data: json['data'] == null ? null : Vimeo.fromJson(json['data'] as Map),
    date: DateTimeUtil.fromTimestamp(json['date']),
    hastest: json['hastest'] as bool,
    order: json['order'] as int,
    depend: json['depend'] as String,
    vlist: (json['vlist'] as List)?.map((e) => e as String)?.toList(),
    twatch: json['twatch'] as int,
    tcompleted: json['tcompleted'] as int,
    ttest: json['ttest'] as int,
    tpass: json['tpass'] as int,
    tfail: json['tfail'] as int,
    min: json['min'] as int,
    numQues: json['numQues'] as int,
  );
}

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'sid': instance.sid,
      'vid': instance.vid,
      'status': instance.status,
      'data': Vimeo.utilToJson(instance.data),
      'date': DateTimeUtil.toTimestamp(instance.date),
      'hastest': instance.hastest,
      'order': instance.order,
      'depend': instance.depend,
      'vlist': instance.vlist,
      'twatch': instance.twatch,
      'tcompleted': instance.tcompleted,
      'ttest': instance.ttest,
      'tpass': instance.tpass,
      'tfail': instance.tfail,
      'min': instance.min,
      'numQues': instance.numQues,
    };
