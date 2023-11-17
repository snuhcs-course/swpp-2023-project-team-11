import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/domain/models/topic.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:mobile_app/core/utils/korean_word_parser_util.dart';

// ignore: unused_import
import 'roadmap_screen_controller.dart';

class RoadmapScreen extends GetView<RoadmapScreenController> {
  const RoadmapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: MyColor.purple,
      appBar: ChattingRoomAppBar(
        title: "Sneki의 추천".tr,
      ),
      body: controller.obx((state) {
        if (state!.isEmpty) {
          return Center(child: Text("아직 추천이 만들어지지 않았어요. 조금 더 채팅해주세요".tr));
        }
        return _buildTopicList(state);
      },
          onLoading: const Center(
              child: CircularProgressIndicator(color: MyColor.orange_1))),
      bottomNavigationBar: BottomSnekiButton(
        toBeDisplayed: "새로운 추천을 원해요".tr,
    onPressed: (){controller.onNewRecommendationTap();})
    );
  }

  ListView _buildTopicList(List<Topic> topics) {
    return ListView.separated(
        reverse: false,
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemBuilder: (context, index) {
          return _buildTopicContainer(topics, index);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16);
        },
        itemCount: topics.length);
  }

  Container _buildTopicContainer(List<Topic> topics, int index) => Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Text(
            KoreanWordParserUtil.makeTopicSentence(topics[index].topic),
            textAlign: TextAlign.center,
            softWrap: true,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ))); // need some additional edit
}

// GetPage(
//   name: ,
//   page: () => const RoadmapScreen(),
//   binding: RoadmapScreenBinding(),
// )
