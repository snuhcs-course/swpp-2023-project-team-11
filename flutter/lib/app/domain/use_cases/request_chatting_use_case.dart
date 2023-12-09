import 'package:mobile_app/app/domain/repository_interfaces/chatting_room_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

class RequestChattingUseCase {
  final ChattingRepository _chattingRepository;

  Future<void> call({
    required String counterPartEmail,
    required void Function() whenSuccess,
    required void Function() whenFail,
}) async {
    final result = await _chattingRepository.createChattingRoom(counterPartEmail: counterPartEmail);
    switch(result) {
      case Success() : {
        whenSuccess();
      }
      case Fail() : {
        whenFail();
      }
    }

  }

  RequestChattingUseCase({
    required ChattingRepository chattingRepository,
  }) : _chattingRepository = chattingRepository;
}