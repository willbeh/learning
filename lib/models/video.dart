import 'package:firebase_service_generator/firebase_service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:learning/utils/datetime_util.dart';

part 'video.g.dart';

@JsonSerializable(anyMap: true)
class VimeoSize {
  VimeoSize(this.width, this.height, this.link);

  int width;
  int height;
  String link;

  factory VimeoSize.fromJson(Map<dynamic, dynamic> json) => _$VimeoSizeFromJson(json);

  Map<String, dynamic> toJson() => _$VimeoSizeToJson(this);

  static List<Map<String, dynamic>> utilToJson(List<VimeoSize> vs){
    return vs.map((v) => v.toJson()).toList();
  }
}

@JsonSerializable(anyMap: true)
class VimeoFile {
  VimeoFile(this.quality, this.type, this.link, this.width, this.height);

  String quality;
  String type;
  String link;
  int width;
  int height;

  factory VimeoFile.fromJson(Map<dynamic, dynamic> json) => _$VimeoFileFromJson(json);

  Map<String, dynamic> toJson() => _$VimeoFileToJson(this);

  static List<Map<String, dynamic>> utilToJson(List<VimeoFile> vs){
    return vs.map((v) => v.toJson()).toList();
  }
}

@JsonSerializable(anyMap: true)
class VimeoPicture {
  VimeoPicture(this.uri, this.sizes);

  String uri;
  @JsonKey( toJson: VimeoSize.utilToJson)
  List<VimeoSize> sizes;

  factory VimeoPicture.fromJson(Map<dynamic, dynamic> json) => _$VimeoPictureFromJson(json);

  Map<String, dynamic> toJson() => _$VimeoPictureToJson(this);

  static Map<String, dynamic> utilToJson(VimeoPicture vs){
    return vs.toJson();
  }
}

@JsonSerializable(anyMap: true)
class VimeoUser {
  VimeoUser(this.uri, this.name, this.pictures);

  String uri;
  String name;
  @JsonKey( toJson: VimeoPicture.utilToJson)
  VimeoPicture pictures;

  factory VimeoUser.fromJson(Map<dynamic, dynamic> json) => _$VimeoUserFromJson(json);

  Map<String, dynamic> toJson() => _$VimeoUserToJson(this);
}


@JsonSerializable(anyMap: true)
class Vimeo {
  Vimeo({this.name, this.description, this.link, this.duration, this.pictures, this.user, this.files, this.width, this.height});

  String name;
  String description;
  String link;
  int duration;
  @JsonKey( toJson: VimeoPicture.utilToJson)
  VimeoPicture pictures;
  VimeoUser user;
  @JsonKey( toJson: VimeoFile.utilToJson)
  List<VimeoFile> files;
  int width;
  int height;

  factory Vimeo.fromJson(Map<dynamic, dynamic> json) => _$VimeoFromJson(json);

  Map<String, dynamic> toJson() => _$VimeoToJson(this);

  static Map<String, dynamic> utilToJson(Vimeo vs){
    return vs.toJson();
  }
}

@FirebaseService(name: 'video', col: 'videos')
@JsonSerializable(anyMap: true)
class Video {
  Video({this.id, this.sid, this.vid, this.status, this.data, this.date, this.order, this.depend, this.vlist,
    this.twatch = 0, this.tcompleted = 0, this.canSkip});

  String id;
  String sid;
  String vid;
  String status;
  @JsonKey( toJson: Vimeo.utilToJson)
  Vimeo data;
  @JsonKey(fromJson: DateTimeUtil.fromTimestamp, toJson: DateTimeUtil.toTimestamp)
  DateTime date;
  int order;
  String depend;
  List<String> vlist;
  int twatch;
  int tcompleted;
  bool canSkip;

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}



/// run - flutter pub run build_runner build