import 'package:mobile_app/app/domain/models/advice.dart';

abstract class AdviceRepository {
  /// API : 이거는 앱에 딱 들어왔을 때, 기존 로드맵 어드바이스 목록을 불러오는 용도
  /// endPoint : chatting-rooms/advices?limit={n}
  ///
  /// <request>
  /// - chattingRoomId
  /// - limit
  /// - sessionId in header
  /// <response>
  ///
  Future<List<Advice>> readAdvices({required String chattingRoomId, required int limit});


  /// API : 소켓 안 열고, 앱 상에서 주기적으로 fetch해오자고 했던 것으로 기억, 그 용도
  /// endPoint : chatting-rooms/advice
  ///
  /// <request>
  /// - chattingRoomId
  /// - sessionId in header
  /// - 기존에 있는거 말고 새로운거 보내줘야 할 것 같은데 리퀘스트에 뭘 담아줘야 효율적일지 모르겠음. 알아서 정해줘요잉
  /// - > timestamp?
  /// - > 마지막으로 온 advice id?
  /// <response>
  /// advice 하나 새로운 놈을 리턴
  Future<Advice> readAdvice({required String chattingRoomId});
}