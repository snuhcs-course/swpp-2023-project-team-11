import 'package:mobile_app/app/domain/service_interfaces/chatting_service.dart';

class SendChatUseCase {
  final ChattingService _chattingService;

  call({required String chatText, required String chattingRoomId,}) {
    print("send chat");
    _chattingService.sendChat(chatText: chatText, chattingRoomId: chattingRoomId);
  }

  const SendChatUseCase({
    required ChattingService chattingService,
  }) : _chattingService = chattingService;
}