// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(
    id: json['id'] as String,
    name: json['name'] as String,
    desc: json['desc'] as String,
    image: json['image'] as String,
    status: json['status'] as String,
    authors: (json['authors'] as List)?.map((e) => e as String)?.toList(),
    icon: json['icon'] as String,
  );
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'icon': instance.icon,
      'image': instance.image,
      'status': instance.status,
      'authors': instance.authors,
    };
