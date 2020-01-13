import 'package:json_annotation/json_annotation.dart';
import 'package:learning/models/video.dart';

part 'watch.g.dart';

@JsonSerializable(anyMap: true)
class Watch {
  Watch({this.id, this.vid, this.uid, this.data, this.position = 0, this.furthest = 0, this.status = ''});

  String id;
  String vid;
  String uid;
  Vimeo data;
  int position;
  int furthest;
  String status;


  factory Watch.fromJson(Map<String, dynamic> json) => _$WatchFromJson(json);

  Map<String, dynamic> toJson() => _$WatchToJson(this);
}



/// run - flutter pub run build_runner build