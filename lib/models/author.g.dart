// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map<String, dynamic> json) {
  return Author(
    uid: json['uid'] as String,
    image: json['image'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'image': instance.image,
    };
