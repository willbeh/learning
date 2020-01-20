import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable(anyMap: true)
class QOption {
  QOption({this.option, this.optCode});

  String option;
  String optCode;

  factory QOption.fromJson(Map<dynamic, dynamic> json) => _$QOptionFromJson(json);

  Map<String, dynamic> toJson() => _$QOptionToJson(this);
}

@JsonSerializable(anyMap: true)
class Question {
  Question({this.id, this.vid, this.question, this.options, this.status = '', this.order});

  String id;
  String vid;
  String question;
  List<QOption> options;
  String answer;
  String status;
  int order;

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}



/// run - flutter pub run build_runner build