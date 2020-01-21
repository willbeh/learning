import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable(anyMap: true)
class QOption {
  QOption({this.option, this.code, this.type, this.selected});

  String option;
  String code;
  String type;
  int selected;

  factory QOption.fromJson(Map<dynamic, dynamic> json) => _$QOptionFromJson(json);

  Map<String, dynamic> toJson() => _$QOptionToJson(this);

  static List<Map<String, dynamic>> utilToJson(List<QOption> vs){
    return vs.map((v) => v.toJson()).toList();
  }
}

@JsonSerializable(anyMap: true)
class Question {
  Question({this.id, this.vid, this.question, this.options, this.status = '', this.order, this.correct, this.wrong});

  String id;
  String vid;
  String question;
  @JsonKey( toJson: QOption.utilToJson)
  List<QOption> options;
  String answer;
  String status;
  int order;
  int correct;
  int wrong;

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}



/// run - flutter pub run build_runner build