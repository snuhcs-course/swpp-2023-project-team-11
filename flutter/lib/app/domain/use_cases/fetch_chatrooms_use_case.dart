import 'package:mobile_app/app/domain/repository_interfaces/chatting_room_repository.dart';

import '../models/chatting_room.dart';

class FetchChatroomsUseCase {
  final ChattingRepository _chattingRepository;

  Future<void> call(
      {required void Function(List<ChattingRoom> chatrooms) whenSuccess,
      required void Function() whenFail}) async {
    List<ChattingRoom> result = await _chattingRepository.readAll();
    if(result.isNotEmpty) whenSuccess(result);
    else whenFail();
  }

  FetchChatroomsUseCase({
    required ChattingRepository chattingRepository,
  }) : _chattingRepository = chattingRepository;
}
