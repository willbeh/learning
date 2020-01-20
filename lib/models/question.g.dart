// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QOption _$QOptionFromJson(Map json) {
  return QOption(
    option: json['option'] as String,
    optCode: json['optCode'] as String,
  );
}

Map<String, dynamic> _$QOptionToJson(QOption instance) => <String, dynamic>{
      'option': instance.option,
      'optCode': instance.optCode,
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
  )..answer = json['answer'] as String;
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'vid': instance.vid,
      'question': instance.question,
      'options': instance.options,
      'answer': instance.answer,
      'status': instance.status,
      'order': instance.order,
    };
