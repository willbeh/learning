// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppBanner _$AppBannerFromJson(Map<String, dynamic> json) {
  return AppBanner(
    id: json['id'] as String,
    image: json['image'] as String,
    status: json['status'] as String,
    link: json['link'] as String,
  )..order = json['order'] as int;
}

Map<String, dynamic> _$AppBannerToJson(AppBanner instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'order': instance.order,
      'status': instance.status,
      'link': instance.link,
    };
