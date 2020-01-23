// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Series _$SeriesFromJson(Map<String, dynamic> json) {
  return Series(
    id: json['id'] as String,
    name: json['name'] as String,
    desc: json['desc'] as String,
    image: json['image'] as String,
    status: json['status'] as String,
    authors: (json['authors'] as List)?.map((e) => e as String)?.toList(),
    hasTest: json['hasTest'] as bool,
    depend: json['depend'] as String,
    list: (json['list'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'image': instance.image,
      'status': instance.status,
      'authors': instance.authors,
      'hasTest': instance.hasTest,
      'depend': instance.depend,
      'list': instance.list,
    };
