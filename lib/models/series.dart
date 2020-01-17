import 'package:json_annotation/json_annotation.dart';

part 'series.g.dart';

@JsonSerializable()
class Series {
  Series({this.id, this.name, this.desc, this.image, this.status});

  String id;
  String name;
  String desc;
  String image;
  String status;


  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}





/// run - flutter pub run build_runner build