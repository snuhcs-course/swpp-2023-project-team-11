import 'package:mobile_app/app/domain/service_interfaces/chatting_service.dart';

class DisconnectChattingChannelUseCase {
  final ChattingService chattingService;
  void call() {
    chattingService.closeChannel();
  }

  const DisconnectChattingChannelUseCase({
    required this.chattingService,
  });
}