import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/models/topic.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_topics_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/update_intimacy_use_case.dart';

class RoadmapScreenController extends GetxController  with StateMixin<List<Topic>> {

  final FetchTopicsUseCase _fetchTopicsUseCase;
  final UpdateIntimacyUseCase _updateIntimacyUseCase;
  final ScrollController scrollController = ScrollController();
  final ChattingRoom chattingRoom = Get.arguments as ChattingRoom;

  void onNewRecommendationTap(){
    change(null, status: RxStatus.loading());
    _fetchTopicsUseCase(chattingRoomId: chattingRoom.id, whenSuccess: (topics){
      change(topics, status: RxStatus.success());
      // topics.add(Topic(topicId: 0, topic: "second topic", tag: "C"));
      // topics.add(Topic(topicId: 0, topic: "3rd topic", tag: "C"));
      // topics.add(Topic(topicId: 0, topic: "4 topic", tag: "C"));
      // topics.add(Topic(topicId: 0, topic: "5 topic", tag: "C"));
      // topics.add(Topic(topicId: 0, topic: "6 topic", tag: "C"));
      // topics.add(Topic(topicId: 0, topic: "7 topic", tag: "C"));

    }, whenFail: (){});
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    change(null, status: RxStatus.loading());
    _fetchTopicsUseCase(chattingRoomId: chattingRoom.id, whenSuccess: (topics){
      change(topics, status: RxStatus.success());
      topics.add(const Topic(topicId: 0, topic: "second topic", tag: "C"));
      topics.add(const Topic(topicId: 0, topic: "3rd topic", tag: "C"));
      // topics.add(Topic(topicId: 0, topic: "4 topic", tag: "C"));
      // topics.add(Topic(topicId: 0, topic: "5 topic", tag: "C"));
      // topics.add(Topic(topicId: 0, topic: "6 topic", tag: "C"));
      // topics.add(Topic(topicId: 0, topic: "7 topic", tag: "C"));

    }, whenFail: (){});
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  RoadmapScreenController({
    required FetchTopicsUseCase fetchTopicsUseCase,
    required UpdateIntimacyUseCase updateIntimacyUseCase,
  })  : _fetchTopicsUseCase = fetchTopicsUseCase,
        _updateIntimacyUseCase = updateIntimacyUseCase;
}