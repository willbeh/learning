import 'package:firebase_service_generator/firebase_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@FirebaseService(name: 'profile', col: 'profiles')
@JsonSerializable()
class Profile {
  Profile({this.id, this.name, this.email, this.phone, this.photo, this.photoUrl, this.token, this.setup});

  String id;
  String name;
  String email;
  String phone;
  @JsonKey(name: 'photo_path')
  String photo;
  @JsonKey(name: 'photo_url')
  String photoUrl;
  String token;
  bool setup;

  
  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}





/// run - flutter pub run build_runner build --delete-conflicting-outputs