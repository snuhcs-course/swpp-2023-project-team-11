import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/models/topic.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_topics_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/send_chat_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/update_intimacy_use_case.dart';
import 'package:mobile_app/core/constants/system_strings.dart';

class RoadmapScreenController extends GetxController
    with StateMixin<List<Topic>> {
  final FetchTopicsUseCase _fetchTopicsUseCase;
  final UpdateIntimacyUseCase _updateIntimacyUseCase;
  final SendChatUseCase _sendChatUseCase;
  final ScrollController scrollController = ScrollController();
  final ChattingRoom chattingRoom = Get.arguments as ChattingRoom;

  void onNewRecommendationTap() {
    change(null, status: RxStatus.loading());
    _fetchTopicsUseCase(
        chattingRoomId: chattingRoom.id,
        whenSuccess: (topics) {
          change(topics, status: RxStatus.success());
          // topics.add(Topic(topicId: 0, topic: "second topic", tag: "C"));
          // topics.add(Topic(topicId: 0, topic: "3rd topic", tag: "C"));
          // topics.add(Topic(topicId: 0, topic: "4 topic", tag: "C"));
          // topics.add(Topic(topicId: 0, topic: "5 topic", tag: "C"));
          // topics.add(Topic(topicId: 0, topic: "6 topic", tag: "C"));
          // topics.add(Topic(topicId: 0, topic: "7 topic", tag: "C"));
        },
        whenFail: () {});
  }

  void onSuggestionBubbleTap(Topic topic) {
    // send the roadmap topic as a chat
    _sendChatUseCase.call(
      chatText: "${roadmap_prefix}${jsonEncode(topic)}",
      chattingRoomId: chattingRoom.id.toString(),
    );

    // validchattingroom controller에 안넣어도 괜찮을까요!?
    // put the sent chat into validchattingroom controller
    // RoomScreenController roomScreenController =
    //     Get.find(tag: chattingRoom.id.toString());
    // Get.find<ValidChattingRoomController>(
    //   tag: chattingRoom.id.toString(),
    // ).addChat(
    //   Chat(
    //     seqId: roomScreenController.tempSeqId--,
    //     chattingRoomId: chattingRoom.id,
    //     senderName: chattingRoom.initiator.name,
    //     // not accurate
    //     senderEmail: chattingRoom.initiator.email,
    //     // not accurate
    //     message: "${roadmap_prefix}${jsonEncode(topic)}",
    //     sentAt: DateTime.now(),
    //   ),
    //   true,
    // );

    Get.delete(tag: chattingRoom.id.toString());
    Get.back();

  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    change(null, status: RxStatus.loading());
    _fetchTopicsUseCase(
        chattingRoomId: chattingRoom.id,
        whenSuccess: (topics) {
          change(topics, status: RxStatus.success());
        },
        whenFail: () {});
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  RoadmapScreenController({
    required FetchTopicsUseCase fetchTopicsUseCase,
    required UpdateIntimacyUseCase updateIntimacyUseCase,
    required SendChatUseCase sendChatUseCase,
  })  : _fetchTopicsUseCase = fetchTopicsUseCase,
        _updateIntimacyUseCase = updateIntimacyUseCase,
        _sendChatUseCase = sendChatUseCase;
}
