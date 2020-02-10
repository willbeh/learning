// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QOption _$QOptionFromJson(Map json) {
  return QOption(
    option: json['option'] as String,
    code: json['code'] as String,
  );
}

Map<String, dynamic> _$QOptionToJson(QOption instance) => <String, dynamic>{
      'option': instance.option,
      'code': instance.code,
    };

Question _$QuestionFromJson(Map json) {
  return Question(
    question: json['question'] as String,
    code: json['code'] as String,
    image: json['image'] as String,
    options: (json['options'] as List)
        ?.map((e) => e == null ? null : QOption.fromJson(e as Map))
        ?.toList(),
    answer: (json['answer'] as List)?.map((e) => e as String)?.toList(),
    type: json['type'] as String,
  );
}

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'question': instance.question,
      'code': instance.code,
      'image': instance.image,
      'options': QOption.utilToJson(instance.options),
      'answer': instance.answer,
      'type': instance.type,
    };

Exam _$ExamFromJson(Map json) {
  return Exam(
    id: json['id'] as String,
    name: json['name'] as String,
    desc: json['desc'] as String,
    image: json['image'] as String,
    sid: json['sid'] as String,
    status: json['status'] as String,
    questions: (json['questions'] as List)
        ?.map((e) => e == null
            ? null
            : Question.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    min: json['min'] as int,
    passed: json['passed'] as int,
    failed: json['failed'] as int,
  );
}

Map<String, dynamic> _$ExamToJson(Exam instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'image': instance.image,
      'sid': instance.sid,
      'status': instance.status,
      'questions': Question.utilToJson(instance.questions),
      'min': instance.min,
      'passed': instance.passed,
      'failed': instance.failed,
    };
