import 'package:firebase_service_generator/firebase_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exam.g.dart';

@JsonSerializable(anyMap: true)
class QOption {
  QOption({this.option, this.code});

  String option;
  String code;

  factory QOption.fromJson(Map<dynamic, dynamic> json) => _$QOptionFromJson(json);

  Map<String, dynamic> toJson() => _$QOptionToJson(this);

  static List<Map<String, dynamic>> utilToJson(List<QOption> vs){
    return vs.map((v) => v.toJson()).toList();
  }
}

@JsonSerializable(anyMap: true)
class Question {
  Question({this.question, this.image, this.options, this.answer, this.type});

  String question;
  String image;
  @JsonKey( toJson: QOption.utilToJson)
  List<QOption> options;
  List<String> answer;
  String type;

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@FirebaseService(name: 'exam', col: 'exams')
@JsonSerializable(anyMap: true)
class Exam {
  Exam({this.id, this.name, this.desc, this.image, this.sid, this.status, this.questions, this.min, this.passed, this.failed});

  String id;
  String name;
  String desc;
  String image;
  String sid;
  String status;
  List<Question> questions;
  int min;
  int passed;
  int failed;

  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);

  Map<String, dynamic> toJson() => _$ExamToJson(this);
}



/// run - flutter pub run build_runner build