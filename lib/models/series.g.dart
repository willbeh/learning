// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Series _$SeriesFromJson(Map json) {
  return Series(
    id: json['id'] as String,
    cid: json['cid'] as String,
    cname: json['cname'] as String,
    name: json['name'] as String,
    desc: json['desc'] as String,
    image: json['image'] as String,
    thumb: json['thumb'] as String,
    status: json['status'] as String,
    authors: (json['authors'] as List)
        ?.map((e) => e == null
            ? null
            : Author.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    hasTest: json['hasTest'] as bool,
    depend: json['depend'] as String,
    list: (json['list'] as List)?.map((e) => e as String)?.toList(),
    order: json['order'] as int,
    watched: json['watched'] as int,
    completed: json['completed'] as int,
    header: json['header'] as String,
    subHeader: json['subHeader'] as String,
    about: json['about'] as String,
    pass: json['pass'] as int,
    fail: json['fail'] as int,
  );
}

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
      'id': instance.id,
      'cid': instance.cid,
      'cname': instance.cname,
      'name': instance.name,
      'desc': instance.desc,
      'image': instance.image,
      'thumb': instance.thumb,
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
      'pass': instance.pass,
      'fail': instance.fail,
    };
