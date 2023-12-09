import 'package:mobile_app/app/domain/service_interfaces/chatting_service.dart';

class SendChatUseCase {
  final ChattingService _chattingService;

  call({
    required String chatText,
    required String chattingRoomId,
    required int proxyId,
  }) {
    _chattingService.sendChat(
      chatText: chatText,
      chattingRoomId: chattingRoomId,
      proxyId: proxyId.toString(),
    );
  }

  const SendChatUseCase({
    required ChattingService chattingService,
  }) : _chattingService = chattingService;
}
