import 'package:json_annotation/json_annotation.dart';

part 'series.g.dart';

@JsonSerializable()
class Series {
  Series({this.id, this.name, this.desc, this.image, this.status, this.authors, this.hasTest, this.depend, this.list});

  String id;
  String name;
  String desc;
  String image;
  String status;
  List<String> authors;
  bool hasTest;
  String depend;
  List<String> list;


  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}





/// run - flutter pub run build_runner build