import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/result.dart';

abstract class ChattingRepository {
  /// API : 채팅 목록을 불러옵니다
  /// endPoint : /chatting-rooms
  ///
  /// <request>
  /// 헤더에 세션 아이디가 담겨 있다.
  /// <response>
  /// 채팅 리스트를 불러온다.
  /// 마찬가지로 몇개나 불러올지 고민이 필요할 수 있으나 일단 하지 맙시다 ㅋ
  /// 원래같으면 로컬에서 캐시도 고민을 좀 해야할텐데 일단 고려하지 않는 것으로
  Future<Result<List<ChattingRoom>, DefaultIssue>> readAllWhereApproved();

  Future<Result<List<ChattingRoom>, DefaultIssue>> readAllWhereNotApproved();

  Future<Result<ChattingRoom, DefaultIssue>> createChattingRoom({required String counterPartEmail});

  Future<Result<ChattingRoom, DefaultIssue>> updateChattingRoom({required int chattingRoomId});

  Future<Result<ChattingRoom, DefaultIssue>> deleteChattingRoom({required int chattingRoomId});
}