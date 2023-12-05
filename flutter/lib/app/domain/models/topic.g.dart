// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
      topic_kor: json['topic_kor'] as String,
      topic_eng: json['topic_eng'] as String,
      tag: json['tag'] as String,
    );

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'topic_kor': instance.topic_kor,
      'topic_eng': instance.topic_eng,
      'tag': instance.tag,
    };
