import 'package:firebase_service_generator/firebase_service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learning/utils/datetime_util.dart';

part 'watch.g.dart';

@FirebaseService(name: 'watch', col: 'watch')
@JsonSerializable()
class Watch {
  Watch({this.id, this.vid, this.vname, this.vpicture, this.vduration, this.uid, this.position = 0, this.furthest = 0, this.status = '', this.test = false, this.date, this.created,
    this.sid,
  });

  String id;
  String vid;
  String vname;
  String vpicture;
  int vduration;
  String uid;
  int position;
  int furthest;
  bool test;
  String status;
  @JsonKey(fromJson: DateTimeUtil.fromTimestamp) //, toJson: DateTimeUtil.toTimestamp)
  DateTime date;
  @JsonKey(fromJson: DateTimeUtil.fromTimestamp) //, toJson: DateTimeUtil.toTimestamp)
  DateTime created;
  String sid;


  factory Watch.fromJson(Map<String, dynamic> json) => _$WatchFromJson(json);

  Map<String, dynamic> toJson() => _$WatchToJson(this);
}



/// run - flutter pub run build_runner build