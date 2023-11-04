import 'package:mobile_app/app/domain/repository_interfaces/chatting_room_repository.dart';
import 'package:mobile_app/app/domain/result.dart';

import '../models/chatting_room.dart';

class FetchChattingRoomsUseCase {
  final ChattingRepository _chattingRepository;

  Future<void> all({
    required void Function(List<ChattingRoom> validRooms, List<ChattingRoom> terminatedRooms, List<ChattingRoom> requestedRooms,) whenSuccess,
    required void Function() whenFail,
  }) async {
    final futureForApprovedResult = _chattingRepository.readAllWhereApproved();
    final futureForUnApprovedResult = _chattingRepository.readAllWhereNotApproved();

    final results = await Future.wait([futureForApprovedResult, futureForUnApprovedResult]);

    final approvedResult = results[0];
    final unApprovedResult = results[1];

    if (approvedResult.isSuccess && unApprovedResult.isSuccess) {
      final List<ChattingRoom> approvedChattingRooms = (approvedResult as Success).data;
      final List<ChattingRoom> unApprovedChattingRooms =(unApprovedResult as Success).data;

      // approved 중에는 terminated 에 따라서 판단해줘야 함.
      final validRooms = approvedChattingRooms.where((element) => !element.isTerminated).toList();
      final terminatedRooms = approvedChattingRooms.where((element) => element.isTerminated).toList();
      // un approved 이면 무조건 requested
      whenSuccess(validRooms, terminatedRooms, unApprovedChattingRooms);
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
