import 'package:json_annotation/json_annotation.dart';

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

@JsonSerializable(anyMap: true)
class Video {
  Video({this.sid, this.vid, this.status, this.data, this.exam});

  String sid;
  String vid;
  String status;
  @JsonKey( toJson: Vimeo.utilToJson)
  Vimeo data;
  bool exam;

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoToJson(this);
}



/// run - flutter pub run build_runner build