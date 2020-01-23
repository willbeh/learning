import 'package:firebase_service_generator/firebase_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@FirebaseService(name: 'category', col: 'categories')
@JsonSerializable()
class Category {
  Category({this.id, this.name, this.desc, this.image, this.status, this.authors, this.icon});

  String id;
  String name;
  String desc;
  String icon;
  String image;
  String status;
  List<String> authors;

  
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}





/// run - flutter pub run build_runner build