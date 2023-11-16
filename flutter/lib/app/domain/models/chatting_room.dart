import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/app/domain/models/user.dart';

part 'chatting_room.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, createToJson: false)
class ChattingRoom {

	factory ChattingRoom.fromJson(Map<String, dynamic> json) => _$ChattingRoomFromJson(json);
	// Map<String, dynamic> toJson( instance) => _$ChattingRoomToJson(this);

  @JsonKey(name: "chatting_id")
  final int id;
  @JsonKey(fromJson: User.fromMap)
  final User initiator;
  @JsonKey(fromJson: User.fromMap)
  final User responder;
  final DateTime createdAt;

  final bool isApproved;
  final bool isTerminated;

  const ChattingRoom({
    required this.id,
    required this.initiator,
    required this.responder,
    required this.createdAt,
    required this.isApproved,
    required this.isTerminated,
  });


}

