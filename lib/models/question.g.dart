// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QOption _$QOptionFromJson(Map json) {
  return QOption(
    option: json['option'] as String,
    code: json['code'] as String,
    type: json['type'] as String,
    selected: json['selected'] as int,
  );
}

Map<String, dynamic> _$QOptionToJson(QOption instance) => <String, dynamic>{
      'option': instance.option,
      'code': instance.code,
      'type': instance.type,
      'selected': instance.selected,
    };

Question _$QuestionFromJson(Map json) {
  return Question(
    id: json['id'] as String,
    vid: json['vid'] as String,
    question: json['question'] as String,
    options: (json['options'] as List)
        ?.map((e) => e == null ? null : QOption.fromJson(e as Map))
        ?.toList(),
    status: json['status'] as String,
    order: json['order'] as int,
    correct: json['correct'] as int,
    wrong: json['wrong'] as int,
  )..answer = json['answer'] as String;
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'vid': instance.vid,
      'question': instance.question,
      'options': QOption.utilToJson(instance.options),
      'answer': instance.answer,
      'status': instance.status,
      'order': instance.order,
      'correct': instance.correct,
      'wrong': instance.wrong,
    };
