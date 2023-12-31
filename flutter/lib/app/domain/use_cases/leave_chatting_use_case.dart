

import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/repository_interfaces/chatting_room_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

class LeaveChattingRoomUseCase {
  final ChattingRepository _chattingRepository;

  Future<void> call({
    required int chattingRoomId,
    required void Function(ChattingRoom chattingRoom) whenSuccess,
    required void Function() whenFail,
  }) async {
    final result = await _chattingRepository.deleteChattingRoom(chattingRoomId: chattingRoomId);
    switch(result) {
      case Success(: final data) : {
        whenSuccess(data);
      }
      case Fail() : {
        whenFail();
      }
    }
  }

  const LeaveChattingRoomUseCase({
    required ChattingRepository chattingRepository,
  }) : _chattingRepository = chattingRepository;
}