import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/repository_interfaces/chatting_room_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

class AcceptChattingRequestUseCase {
  final ChattingRepository _chattingRepository;

  Future<void> call({
    required int chattingRoomId,
    required void Function(ChattingRoom chattingRoom) whenSuccess,
    required void Function() whenFail,
  }) async {
    final result = await _chattingRepository.updateChattingRoom(chattingRoomId: chattingRoomId);
    switch(result) {
      case Success(: final data) : {
        print("new fetched chatting room id");
        print(data.id);
        whenSuccess(data);
      }
      case Fail() : {
        whenFail();
      }
    }
  }

  const AcceptChattingRequestUseCase({
    required ChattingRepository chattingRepository,
  }) : _chattingRepository = chattingRepository;
}
