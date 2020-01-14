import 'package:json_annotation/json_annotation.dart';

part 'answer.g.dart';

@JsonSerializable(anyMap: true)
class UserAnswer {
  UserAnswer({this.qid, this.answer});

  String qid;
  String answer;

  factory UserAnswer.fromJson(Map<String, dynamic> json) => _$UserAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$UserAnswerToJson(this);

  static List<Map<String, dynamic>> utilToJson(List<UserAnswer> userAnswers){
    return userAnswers.map((answer) => answer.toJson()).toList();
  }
}

@JsonSerializable(anyMap: true)
class Answer {
  Answer({this.id, this.uid, this.vid, List<UserAnswer> answers, this.status}) : answers = answers ?? <UserAnswer>[];

  String id;
  String uid;
  String vid;
  @JsonKey( toJson: UserAnswer.utilToJson)
  List<UserAnswer> answers;
  String status;


  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}





/// run - flutter pub run build_runner build