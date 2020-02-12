// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAnswer _$UserAnswerFromJson(Map json) {
  return UserAnswer(
    qid: json['qid'] as String,
    answer: (json['answer'] as List)?.map((e) => e as String)?.toList(),
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
    sid: json['sid'] as String,
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
    pass: json['pass'] as bool,
    date: DateTimeUtil.fromTimestamp(json['date']),
    completed: DateTimeUtil.fromTimestamp(json['completed']),
  );
}

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'sid': instance.sid,
      'answers': UserAnswer.utilToJson(instance.answers),
      'status': instance.status,
      'correct': instance.correct,
      'min': instance.min,
      'pass': instance.pass,
      'date': DateTimeUtil.toTimestamp(instance.date),
      'completed': DateTimeUtil.toTimestamp(instance.completed),
    };
