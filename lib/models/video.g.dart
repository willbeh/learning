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
    json['link_with_play_button'] as String,
  );
}

Map<String, dynamic> _$VimeoSizeToJson(VimeoSize instance) => <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'link': instance.link,
      'link_with_play_button': instance.link_with_play_button,
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
      'sizes': instance.sizes,
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
      'pictures': instance.pictures,
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
      'pictures': instance.pictures,
      'user': instance.user,
      'files': instance.files,
      'width': instance.width,
      'height': instance.height,
    };

Video _$VideoFromJson(Map json) {
  return Video(
    vid: json['vid'] as String,
    status: json['status'] as String,
    data: json['data'] == null ? null : Vimeo.fromJson(json['data'] as Map),
  );
}

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'vid': instance.vid,
      'status': instance.status,
      'data': instance.data,
    };
