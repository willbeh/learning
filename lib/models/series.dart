import 'package:firebase_service_generator/firebase_service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learning/models/author.dart';

part 'series.g.dart';

@FirebaseService(name: 'series', col: 'series')
@JsonSerializable(anyMap: true)
class Series {
  Series({this.id, this.cid, this.cname, this.name, this.desc, this.image, this.thumb, this.status, this.authors, this.hasTest, this.depend, this.list,
    this.order, this.watched, this.completed, this.header, this.subHeader, this.about, this.pass, this.fail,
  });

  String id;
  String cid;
  String cname;
  String name;
  String desc;
  String image;
  String thumb;
  String status;
  List<Author> authors;
  bool hasTest;
  String depend;
  List<String> list;
  int order;
  int watched;
  int completed;
  String header;
  String subHeader;
  String about;
  int pass;
  int fail;


  factory Series.fromJson(Map<dynamic, dynamic> json) => _$SeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}





/// run - flutter pub run build_runner build