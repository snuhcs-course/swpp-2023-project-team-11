import 'package:mobile_app/app/domain/models/friendship.dart';

abstract class FriendshipRepository {
  /// API : 채팅 중에 friendship이 진화할수도 있잖슴? 어떤 트리거가 생긴다면 그 때 다시 fetch해오기 위해서
  /// endPoint : /chatting-rooms/friendship
  ///
  /// <request>
  /// - chattingRoomId
  /// - sessionId in header
  /// <response>
  /// friendship 하나 리턴
  Future<Friendship> readByChattingRoomId({required String chattingRoomId});
}