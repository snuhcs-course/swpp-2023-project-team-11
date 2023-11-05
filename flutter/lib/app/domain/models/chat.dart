import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Chat {
  final int seqId;
  @JsonKey(name: "chatting_id")
  final int chattingRoomId;
  @JsonKey(name: "sender")
  final String senderName;
  @JsonKey(name: "email")
  final String senderEmail;
  @JsonKey(name: "msg")
  final String message;
  @JsonKey(name: "timestamp")
  final DateTime sentAt;

  
  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);
  
  Map<String, dynamic> toJson() => _$ChatToJson(this);


  const Chat({
    required this.seqId,
    required this.chattingRoomId,
    required this.senderName,
    required this.senderEmail,
    required this.message,
    required this.sentAt,
  });
}
