import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

abstract class Chat {
  final ChatType messageType;
  final String id;
  final String senderId;
  final String text;
  final DateTime sentAt;

  const Chat({
    required this.messageType,
    required this.id,
    required this.senderId,
    required this.text,
    required this.sentAt,
  });

  factory Chat.normal({
    required ChatType messageType,
    required String id,
    required String text,
    required String senderId,
    required DateTime sentAt,
  }) {
    return NormalChat(
      messageType: ChatType.normal,
      id: id,
      text: text,
      senderId: senderId,
      sentAt: sentAt,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class NormalChat extends Chat {
  NormalChat({
    required super.messageType,
    required super.id,
    required super.text,
    required super.senderId,
    required super.sentAt,
  });

  factory NormalChat.fromJson(Map<String, dynamic> json) => _$NormalChatFromJson(json);

  Map<String, dynamic> toJson() => _$NormalChatToJson(this);
}


enum ChatType {
  normal,
}
