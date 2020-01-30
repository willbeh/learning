import 'package:firebase_service_generator/firebase_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'series.g.dart';

@FirebaseService(name: 'series', col: 'series')
@JsonSerializable()
class Series {
  Series({this.id, this.name, this.desc, this.image, this.status, this.authors, this.hasTest, this.depend, this.list,
    this.order, this.watched, this.completed, this.header, this.subHeader, this.about,
  });

  String id;
  String name;
  String desc;
  String image;
  String status;
  List<String> authors;
  bool hasTest;
  String depend;
  List<String> list;
  int order;
  int watched;
  int completed;
  String header;
  String subHeader;
  String about;


  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}





/// run - flutter pub run build_runner build