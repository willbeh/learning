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
    order: json['order'] as int,
    watched: json['watched'] as int,
    completed: json['completed'] as int,
    header: json['header'] as String,
    subHeader: json['subHeader'] as String,
    about: json['about'] as String,
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
      'order': instance.order,
      'watched': instance.watched,
      'completed': instance.completed,
      'header': instance.header,
      'subHeader': instance.subHeader,
      'about': instance.about,
    };
