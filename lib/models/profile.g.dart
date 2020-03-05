// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    photo: json['photo_path'] as String,
    photoUrl: json['photo_url'] as String,
    token: json['token'] as String,
    setup: json['setup'] as bool,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'photo_path': instance.photo,
      'photo_url': instance.photoUrl,
      'token': instance.token,
      'setup': instance.setup,
    };
