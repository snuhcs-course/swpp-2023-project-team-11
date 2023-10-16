import 'package:mobile_app/app/domain/models/chat.dart';

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
  Future<List<Chat>> readMessages({required String chattingRoomId,required int limit});

  /// API : 메시지 목록을 불러오는 웹소켓을 연결한다 채팅방별로.
  /// endPoint : 소켓은 어케 써야하지 아몰랑.. 파베 sdk로 소켓 연결한 적 밖에 엄써서..
  ///
  /// <request>
  /// - chattingId
  /// - sessionId in header
  /// <response>
  /// Stream 객체는 플러터에서 웹소켓을 처리하는 방식입니다. 여기로 계속 메시지가 넘어옵니당.
  Stream<Chat> subscribeMessagesByChattingId({required String chattingRoomId});

  /// API : 채팅방 별로 웹소켓 연결을 종료한다.
  /// endPoint : 소켓은 어케 써야하지 아몰랑
  ///
  /// <request>
  /// - chattingId
  /// - sessionId in header
  /// <response>
  ///
  Future<void> unsubscribeMessagesByChattingId({required String chattingRoomId});

  /// API : 채팅을 하나 보낸다.
  /// endPoint : /chatting-rooms/chats
  ///
  /// <request>
  /// - chatText
  /// - chatType (string 바꿔서)
  /// <response>
  ///
  Future<void> sendChat({required String chatText, required ChatType chatType});
}