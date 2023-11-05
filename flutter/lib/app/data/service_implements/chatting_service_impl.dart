import 'dart:convert';

import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/service_interfaces/chatting_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChattingServiceImpl implements ChattingService {
  static WebSocketChannel? chatSocketChannel;
  static const _chatWebSocketUrl = "ws://3.35.9.226:8000/ws/connect";

  @override
  Stream initChatConnection({required String sessionKey, required void Function(Chat chat) onMessageChatReceive,}) {
    chatSocketChannel = WebSocketChannel.connect(Uri.parse(_chatWebSocketUrl));
    chatSocketChannel!.stream.listen((event) {
      final decoded = jsonDecode(event);
      if (decoded["type"] == "system") {
        print("system message : ${decoded["body"]}");
      }
      if (decoded["type"] == "message") {
        final body = decoded["body"];
        final chat = Chat.fromJson(body);
        onMessageChatReceive(chat);
      }
    });
    chatSocketChannel!.sink.add(jsonEncode({
      "type": "system",
      "body": {"session_key": sessionKey}
    }));

    return chatSocketChannel!.stream;
  }

  @override
  Future<List<Chat>> readMessages({required String chattingRoomId, required int limit}) {
    // TODO: implement readMessages
    throw UnimplementedError();
  }

  @override
  Future<void> sendChat({required String chatText, required String chattingRoomId}) async {
    chatSocketChannel!.sink.add(jsonEncode(
      {
        "type": "message",
        "body": {
          "chatting_id": chattingRoomId,
          "msg": chatText,
        },
      },
    ));
  }

  @override
  Stream<Chat> subscribeMessagesByChattingId({required String chattingRoomId}) {
    // TODO: implement subscribeMessagesByChattingId
    throw UnimplementedError();
  }

  @override
  Future<void> unsubscribeMessagesByChattingId({required String chattingRoomId}) {
    // TODO: implement unsubscribeMessagesByChattingId
    throw UnimplementedError();
  }

}
