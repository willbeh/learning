import 'package:firebase_service_generator/firebase_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'author.g.dart';

@JsonSerializable()
class Author {
  Author({this.uid, this.image, this.name});

  String uid;
  String name;
  String image;

  
  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}





/// run - flutter pub run build_runner build --delete-conflicting-outputs