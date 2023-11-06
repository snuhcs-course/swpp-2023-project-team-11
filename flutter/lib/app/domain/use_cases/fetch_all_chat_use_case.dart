import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/result.dart';
import 'package:mobile_app/app/domain/service_interfaces/chatting_service.dart';

class FetchAllChatUseCase {
  final ChattingService _chattingService;

  Future<void> call({
    required String chattingRoomId,
    int? limit,
    int? sequenceId,
    required void Function(List<Chat> chats) whenSuccess,
    required void Function() whenFail,
  }) async {
    final result = await _chattingService.readMessages(
      chattingRoomId: chattingRoomId,
      limit: limit,
      sequenceId: sequenceId,
    );
    switch(result) {
      case Success(:final data) : {
        whenSuccess(data.reversed.toList());
      }
      case Fail() : {
        whenFail();
      }
    }
  }

  const FetchAllChatUseCase({
    required ChattingService chattingService,
  }) : _chattingService = chattingService;
}
