import 'package:mobile_app/app/domain/repository_interfaces/chatting_room_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

import '../models/chatting_room.dart';

class FetchChattingRoomsUseCase {
  final ChattingRepository _chattingRepository;

  Future<void> all({
    required String email,
    required void Function(
      List<ChattingRoom> validRooms,
      List<ChattingRoom> terminatedRooms,
      List<ChattingRoom> requestingRooms,
      List<ChattingRoom> requestedRooms,
    ) whenSuccess,
    required void Function() whenFail,
  }) async {
    final futureForApprovedResult = _chattingRepository.readAllWhereApproved();
    final futureForUnApprovedResult = _chattingRepository.readAllWhereNotApproved();

    final results = await Future.wait([futureForApprovedResult, futureForUnApprovedResult]);

    final approvedResult = results[0];
    final unApprovedResult = results[1];

    if (approvedResult.isSuccess && unApprovedResult.isSuccess) {
      final List<ChattingRoom> approvedChattingRooms = (approvedResult as Success).data;
      final List<ChattingRoom> unApprovedChattingRooms = (unApprovedResult as Success).data;

      // approved 중에는 terminated 에 따라서 판단해줘야 함.
      final validRooms = approvedChattingRooms.where((element) => !element.isTerminated).toList();
      final terminatedRooms =
          approvedChattingRooms.where((element) => element.isTerminated).toList();
      // un approved 이면 무조건 requested
      // 다만 누가 initiator 이냐에 따라 달라짐.
      final List<ChattingRoom> requestingRooms = [];
      final List<ChattingRoom> requestedRooms = [];
      for (final unApprovedRoom in unApprovedChattingRooms) {
        // un approve중에 내가 만든 채팅방이 있다면
        if (unApprovedRoom.initiator.email == email) {
          requestingRooms.add(unApprovedRoom);
        } else {
          requestedRooms.add(unApprovedRoom);
        }
      }

      whenSuccess(validRooms, terminatedRooms, requestingRooms,requestedRooms);
    } else {
      whenFail();
    }
  }

  Future<void> valid({
    required void Function(List<ChattingRoom> chatrooms) whenSuccess,
    required void Function() whenFail,
  }) async {
    final result = await _chattingRepository.readAllWhereApproved();

    switch (result) {
      case Success(data: final rooms):
        {
          whenSuccess(rooms);
        }
      case Fail():
        {
          whenFail();
        }
    }
  }

  Future<void> requested({
    required void Function(List<ChattingRoom> chatrooms) whenSuccess,
    required void Function() whenFail,
  }) async {
    final result = await _chattingRepository.readAllWhereNotApproved();

    switch (result) {
      case Success(data: final rooms):
        {
          whenSuccess(rooms);
        }
      case Fail():
        {
          whenFail();
        }
    }
  }

  FetchChattingRoomsUseCase({
    required ChattingRepository chattingRepository,
  }) : _chattingRepository = chattingRepository;
}
