import 'package:firebase_service_generator/firebase_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'banner.g.dart';

@FirebaseService(name: 'banner', col: 'banners')
@JsonSerializable()
class AppBanner {
  AppBanner({this.id, this.image, this.status, this.link});

  String id;
  String image;
  int order;
  String status;
  String link;

  
  factory AppBanner.fromJson(Map<String, dynamic> json) => _$AppBannerFromJson(json);

  Map<String, dynamic> toJson() => _$AppBannerToJson(this);
}





/// run - flutter pub run build_runner build --delete-conflicting-outputs