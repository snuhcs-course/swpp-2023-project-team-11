import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Topic {
  // @JsonKey(name: "topic_id")
  // final int topicId;
  @JsonKey(name: "topic")
  final String topic;
  @JsonKey(name: "tag")
  final String tag;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);

  const Topic({
    // required this.topicId,
    required this.topic,
    required this.tag,
  });
}