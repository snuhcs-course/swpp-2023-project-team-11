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
    return NormalChat._(
      messageType: ChatType.normal,
      id: id,
      text: text,
      senderId: senderId,
      sentAt: sentAt,
    );
  }
}

class NormalChat extends Chat {
  NormalChat._({
    required super.messageType,
    required super.id,
    required super.text,
    required super.senderId,
    required super.sentAt,
  });
}


enum ChatType {
  normal,
}
