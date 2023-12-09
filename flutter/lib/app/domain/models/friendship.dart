import 'package:json_annotation/json_annotation.dart';


part 'friendship.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Friendship {

	factory Friendship.fromJson(Map<String, dynamic> json) => _$FriendshipFromJson(json);
	Map<String, dynamic> toJson() => _$FriendshipToJson(this);
  final double intimacy;
  final List<String> recentTopics;

  const Friendship({
    required this.intimacy,
    required this.recentTopics,
  });
}