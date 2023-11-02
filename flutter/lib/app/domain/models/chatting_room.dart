import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/app/domain/models/friendship.dart';
import 'package:mobile_app/app/domain/models/user.dart';

part 'chatting_room.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ChattingRoom {

	factory ChattingRoom.fromJson(Map<String, dynamic> json) => _$ChattingRoomFromJson(json);
	Map<String, dynamic> toJson( instance) => _$ChattingRoomToJson(this);

  final String id;
  final KoreanUser koreanUser;
  final ForeignUser foreignUser;
  final Friendship friendship;
  final DateTime createdAt;

  const ChattingRoom({
    required this.id,
    required this.koreanUser,
    required this.foreignUser,
    required this.friendship,
    required this.createdAt,
  });


}

