

import 'package:mobile_app/app/domain/models/intimacy.dart';
import 'package:mobile_app/app/domain/models/topic.dart';
import 'package:mobile_app/app/domain/result.dart';

abstract class RoadmapRepository{
  /// API : 이거는 앱에 딱 들어왔을 때, 기존 로드맵 어드바이스 목록을 불러오는 용도
  /// endPoint : chatting/topic
  ///
  /// <request>
  /// - chattingRoomId
  /// - sessionId in header
  /// <response>
  /// - List of topics
  /// - topic_id
  /// - topic (String value)
  /// - tag (String value)
  Future<Result<List<Topic>, DefaultIssue>> readTopics({required int chattingRoomId});

  Future<Result<Intimacy, DefaultIssue>> updateIntimacy({required int chattingRoomId});

}