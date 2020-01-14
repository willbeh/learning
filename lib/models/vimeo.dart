import 'package:json_annotation/json_annotation.dart';

part 'vimeo.g.dart';

@JsonSerializable()
class VimeoSize {
  VimeoSize(this.width, this.height, this.link);
  int width;
  int height;
  String link;

  factory VimeoSize.fromJson(Map<String, dynamic> json) => _$VimeoSizeFromJson(json);

  Map<String, dynamic> toJson() => _$VimeoSizeToJson(this);
}

@JsonSerializable()
class VimeoFile {
  VimeoFile(this.quality, this.type, this.link, this.width, this.height);
  String quality;
  String type;
  String link;
  int width;
  int height;

  factory VimeoFile.fromJson(Map<String, dynamic> json) => _$VimeoFileFromJson(json);

  Map<String, dynamic> toJson() => _$VimeoFileToJson(this);
}

@JsonSerializable()
class VimeoPicture {
  VimeoPicture(this.uri, this.sizes);
  String uri;
  List<VimeoSize> sizes;

  factory VimeoPicture.fromJson(Map<String, dynamic> json) => _$VimeoPictureFromJson(json);

  Map<String, dynamic> toJson() => _$VimeoPictureToJson(this);
}

@JsonSerializable()
class VimeoUser {
  VimeoUser(this.uri, this.name, this.pictures);
  String uri;
  String name;
  VimeoPicture pictures;

  factory VimeoUser.fromJson(Map<String, dynamic> json) => _$VimeoUserFromJson(json);

  Map<String, dynamic> toJson() => _$VimeoUserToJson(this);
}


@JsonSerializable()
class Vimeo {
  Vimeo({this.name, this.description, this.link, this.duration, this.pictures, this.user, this.files, this.width, this.height});

  String name;
  String description;
  String link;
  int duration;
  VimeoPicture pictures;
  VimeoUser user;
  List<VimeoFile> files;
  int width;
  int height;


  factory Vimeo.fromJson(Map<String, dynamic> json) => _$VimeoFromJson(json);

  Map<String, dynamic> toJson() => _$VimeoToJson(this);
}



/// run - flutter pub run build_runner build