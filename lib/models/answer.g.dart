// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAnswer _$UserAnswerFromJson(Map json) {
  return UserAnswer(
    qid: json['qid'] as String,
    answer: json['answer'] as String,
  );
}

Map<String, dynamic> _$UserAnswerToJson(UserAnswer instance) =>
    <String, dynamic>{
      'qid': instance.qid,
      'answer': instance.answer,
    };

Answer _$AnswerFromJson(Map json) {
  return Answer(
    id: json['id'] as String,
    uid: json['uid'] as String,
    vid: json['vid'] as String,
    answers: (json['answers'] as List)
        ?.map((e) => e == null
            ? null
            : UserAnswer.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    status: json['status'] as String,
    correct: json['correct'] as int,
    min: json['min'] as int,
  );
}

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'vid': instance.vid,
      'answers': UserAnswer.utilToJson(instance.answers),
      'status': instance.status,
      'correct': instance.correct,
      'min': instance.min,
    };
