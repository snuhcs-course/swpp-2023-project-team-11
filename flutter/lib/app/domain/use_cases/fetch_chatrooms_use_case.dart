import 'package:mobile_app/app/domain/repository_interfaces/chatting_room_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

import '../models/chatting_room.dart';

class FetchChatroomsUseCase {
  final ChattingRepository _chattingRepository;

  Future<void> call(
      {required void Function(List<ChattingRoom> chatrooms) whenSuccess,
      required void Function() whenFail}) async {
    final result = await _chattingRepository.readAllWhereApproved();

    switch(result) {
      case Success(data : final rooms): {
        whenSuccess(rooms);
      }
      case Fail() : {
        whenFail();
      }
    }
  }

  FetchChatroomsUseCase({
    required ChattingRepository chattingRepository,
  }) : _chattingRepository = chattingRepository;
}
