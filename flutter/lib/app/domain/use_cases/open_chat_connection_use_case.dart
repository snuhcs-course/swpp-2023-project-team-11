import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/service_interfaces/auth_service.dart';
import 'package:mobile_app/app/domain/service_interfaces/chatting_service.dart';

class OpenChatConnectionUseCase {
  final ChattingService _chattingService;
  final AuthService _authService;

  Future<Stream> call({required void Function(Chat chat) onReceiveChat,}) async {
    print("open chat connection");
    final storedSessionKey = await _authService.getSessionKey;
    if (storedSessionKey== null) throw Exception("어라 왜 세션 키가 없지");
    return _chattingService.initChatConnection(sessionKey: storedSessionKey, onMessageChatReceive: onReceiveChat);
  }

  const OpenChatConnectionUseCase({
    required ChattingService chattingService,
    required AuthService authService,
  })  : _chattingService = chattingService,
        _authService = authService;
}