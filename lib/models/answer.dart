import 'package:firebase_service_generator/firebase_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'answer.g.dart';

@JsonSerializable(anyMap: true)
class UserAnswer {
  UserAnswer({this.qid, this.answer});

  String qid;
  List<String> answer;

  factory UserAnswer.fromJson(Map<String, dynamic> json) => _$UserAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$UserAnswerToJson(this);

  static List<Map<String, dynamic>> utilToJson(List<UserAnswer> userAnswers){
    return userAnswers.map((answer) => answer.toJson()).toList();
  }
}

@FirebaseService(name: 'answer', col: 'answers')
@JsonSerializable(anyMap: true)
class Answer {
  Answer({this.id, this.uid, this.sid, List<UserAnswer> answers, this.status, this.correct, this.min}) : answers = answers ?? <UserAnswer>[];

  String id;
  String uid;
  String sid;
  @JsonKey( toJson: UserAnswer.utilToJson)
  List<UserAnswer> answers;
  String status;
  int correct;
  int min;


  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}





/// run - flutter pub run build_runner build