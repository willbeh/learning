import 'package:firebase_service_generator/firebase_service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learning/models/series.dart';
import 'package:learning/utils/datetime_util.dart';

part 'series_watch.g.dart';

@FirebaseService(name: 'series_watch', col: 'seriesWatch')
@JsonSerializable(anyMap: true)
class SeriesWatch {
  SeriesWatch({this.id, this.sid, this.sdata, this.uid, this.date});

  String id;
  String sid;
  Series sdata;
  String uid;
  @JsonKey(fromJson: DateTimeUtil.fromTimestamp) //, toJson: DateTimeUtil.toTimestamp)
  DateTime date;


  factory SeriesWatch.fromJson(Map<String, dynamic> json) => _$SeriesWatchFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesWatchToJson(this);
}



/// run - flutter pub run build_runner build