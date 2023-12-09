import 'package:json_annotation/json_annotation.dart';

part 'topic.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Topic {
  // @JsonKey(name: "topic_id")
  // final int topicId;
  @JsonKey(name: "topic_kor")
  final String topic_kor;
  @JsonKey(name: "topic_eng")
  final String topic_eng;
  @JsonKey(name: "tag")
  final String tag;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

  Map<String, dynamic> toJson() => _$TopicToJson(this);

  const Topic({
    // required this.topicId,
    required this.topic_kor,
    required this.topic_eng,
    required this.tag,
  });
}