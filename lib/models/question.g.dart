// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QAns _$QAnsFromJson(Map json) {
  return QAns(
    answer: json['answer'] as String,
    ansCode: json['ansCode'] as String,
  );
}

Map<String, dynamic> _$QAnsToJson(QAns instance) => <String, dynamic>{
      'answer': instance.answer,
      'ansCode': instance.ansCode,
    };

Question _$QuestionFromJson(Map json) {
  return Question(
    id: json['id'] as String,
    vid: json['vid'] as String,
    question: json['question'] as String,
    answers: (json['answers'] as List)
        ?.map((e) => e == null ? null : QAns.fromJson(e as Map))
        ?.toList(),
    status: json['status'] as String,
    order: json['order'] as int,
  );
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'vid': instance.vid,
      'question': instance.question,
      'answers': instance.answers,
      'status': instance.status,
      'order': instance.order,
    };
