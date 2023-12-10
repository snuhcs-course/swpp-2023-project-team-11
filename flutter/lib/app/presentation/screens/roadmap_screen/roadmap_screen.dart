import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/domain/models/topic.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/core/constants/system_strings.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:mobile_app/core/utils/korean_word_parser_util.dart';
import 'package:mobile_app/core/utils/translation.dart';
import 'package:mobile_app/main.dart';

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
            additionalAction: IconButton(
              icon: Icon(Icons.refresh_rounded), onPressed: () {
              controller.onNewRecommendationTap();
            },
            )
        ),
        body: controller.obx((state) {
          return Column(
            children: [
              Center(
                child: Container(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "현재 언어교환 진행도: ".tr, style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                      ),
                      // build heart display
                      (sp.containsKey("${controller.chattingRoom
                          .id}/${lastUpdatedIntimacyValue}")) ? Container(
                        height: 30,
                        child: _buildIntimacyDisplay(sp.getDouble(
                            "${controller.chattingRoom
                                .id}/${lastUpdatedIntimacyValue}")!),
                      ) : Text("진행도 산출을 위해 조금만 더 채팅해주세요".tr, style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16))

                    ],
                  ),
                ),
              ),
              (state!.isEmpty) ? Center(
                  child: Text("아직 추천이 만들어지지 않았어요. 조금 더 채팅해주세요".tr)) : Expanded(
                  child: _buildTopicList(state))
            ],
          );
        },
            onLoading: const Center(
                child: CircularProgressIndicator(color: MyColor.orange_1))),
        bottomNavigationBar: Obx(() {
          return BottomSnekiButton(
              toBeDisplayed: "선택 완료".tr,
              onPressed: controller.selectedTopicExists ? controller
                  .onSelectCompleteButtonTap : null);
        })
    );
  }

  Widget _buildIntimacyDisplay(double intimacyValue) {
    int fullHearts = intimacyValue < 60 ? 1 : intimacyValue < 80 ? 2 : 3;
    // double fraction = rating - fullHearts;
    int emptyHearts = 3 - fullHearts;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < fullHearts; i++)
          Icon(
            Icons.favorite,
            color: MyColor.orange_1,
          ),
        // if (fraction > 0.0)
        //   Icon(
        //     Icons.favorite_border,
        //     color: Colors.red,
        //   ),
        for (int i = 0; i < emptyHearts; i++)
          Icon(
            Icons.favorite_border,
            color: Colors.white.withOpacity(0.7),
          ),
      ],
    );

    // return Text(intimacyValue.toString());
  }

  ListView _buildTopicList(List<Topic> topics) {
    return ListView.separated(
        reverse: false,
        controller: controller.scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        itemBuilder: (context, index) {
          return Obx(() {
            return GestureDetector(
                child: _buildTopicContainer(topics, index),
                onTap: () {
                  controller.onSuggestionBubbleTap(topics[index]);
                });
          });
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16);
        },
        itemCount: topics.length);
  }

  Container _buildTopicContainer(List<Topic> topics, int index) =>
      Container(
          width: double.infinity,
          key: ValueKey(index),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
          decoration: BoxDecoration(
              color: (controller.selectedTopicExists &&
                  (controller.selectedTopic.value!.topic_eng !=
                      topics[index].topic_eng))
                  ? Colors.white.withOpacity(0.6)
                  : Colors.white,
              borderRadius: BorderRadius.circular(10),
            border: (controller.selectedTopicExists && (controller.selectedTopic.value!.topic_eng == topics[index].topic_eng)) ? Border.all(color: MyColor.orange_1, width: 2, strokeAlign: BorderSide.strokeAlignOutside) : null,

          ),
          child: Center(
              child: Text(
                "${"추천".tr} ${index + 1}: ${KoreanWordParserUtil
                    .makeTopicSentence(MyLanguageUtil.isKr
                    ? topics[index].topic_kor
                    : topics[index].topic_eng)}",
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ))); // need some additional edit
}

// GetPage(
//   name: ,
//   page: () => const RoadmapScreen(),
//   binding: RoadmapScreenBinding(),
// )
