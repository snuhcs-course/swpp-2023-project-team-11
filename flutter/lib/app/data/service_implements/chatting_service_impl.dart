import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/service_interfaces/chatting_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChattingServiceImpl implements ChattingService {
  static WebSocketChannel? chatSocketChannel;
  static const _chatWebSocketUrl = "ws://3.35.9.226:8000/ws/connect";
  @override
  Stream openChatStream(String sessionKey) {
    chatSocketChannel = WebSocketChannel.connect(Uri.parse(_chatWebSocketUrl));
    chatSocketChannel!.sink.add({
      "type": "system",
      "body": {
        "session_key": sessionKey,
      }
    });
    return chatSocketChannel!.stream;
  }

  @override
  Future<List<Chat>> readMessages({required String chattingRoomId, required int limit}) {
    // TODO: implement readMessages
    throw UnimplementedError();
  }

  @override
  Future<void> sendChat({required String chatText, required ChatType chatType}) {
    // TODO: implement sendChat
    throw UnimplementedError();
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
