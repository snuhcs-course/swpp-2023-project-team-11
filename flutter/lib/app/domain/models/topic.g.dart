// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
      // topicId: json['topic_id'] as int,
      topic: json['topic'] as String,
      tag: json['tag'] as String,
    );

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      // 'topic_id': instance.topicId,
      'topic': instance.topic,
      'tag': instance.tag,
    };