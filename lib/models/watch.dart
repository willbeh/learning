import 'package:json_annotation/json_annotation.dart';

part 'watch.g.dart';

@JsonSerializable(anyMap: true)
class Watch {
  Watch({this.id, this.vid, this.uid, this.position = 0, this.furthest = 0, this.status = '', this.test = false});

  String id;
  String vid;
  String uid;
  int position;
  int furthest;
  bool test;
  String status;


  factory Watch.fromJson(Map<String, dynamic> json) => _$WatchFromJson(json);

  Map<String, dynamic> toJson() => _$WatchToJson(this);
}



/// run - flutter pub run build_runner build