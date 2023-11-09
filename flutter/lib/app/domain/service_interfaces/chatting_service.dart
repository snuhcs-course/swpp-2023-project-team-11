import 'dart:async';

import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/result.dart';

abstract class ChattingService {
  /// API : 처음으로 메시지 목록을 불러온다. 최근거 한 n개 정도? 몇 개 불러올지는 섭서 정해주소
  /// endPoint : /chatting-rooms/{chattingRoomId}/messages?limit={n}
  ///
  /// <request>
  /// - chattingId in path
  /// - limit in body? queryParams?
  /// - sessionId in header
  ///
  /// <response>
  Future<Result<List<Chat>, DefaultIssue>> readMessages({required String chattingRoomId, int? limit, int? sequenceId, });


  /// API : 채팅을 하나 보낸다.
  /// endPoint : /chatting-rooms/chats
  ///
  /// <request>
  /// - chatText
  /// - chatType (string 바꿔서)
  /// <response>
  ///
  Future<void> sendChat({required String chatText, required String chattingRoomId});

  StreamSubscription initChatConnection({required String sessionKey, required void Function(Chat chat) onMessageChatReceive,});
}