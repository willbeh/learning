import 'package:json_annotation/json_annotation.dart';
import 'package:learning/models/video.dart';

part 'question.g.dart';

@JsonSerializable(anyMap: true)
class QAns {
  QAns({this.answer, this.ansCode});

  String answer;
  String ansCode;

  factory QAns.fromJson(Map<dynamic, dynamic> json) => _$QAnsFromJson(json);

  Map<String, dynamic> toJson() => _$QAnsToJson(this);
}

@JsonSerializable(anyMap: true)
class Question {
  Question({this.id, this.vid, this.question, this.answers, this.status = '', this.order});

  String id;
  String vid;
  String question;
  List<QAns> answers;
  String status;
  int order;

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}



/// run - flutter pub run build_runner build