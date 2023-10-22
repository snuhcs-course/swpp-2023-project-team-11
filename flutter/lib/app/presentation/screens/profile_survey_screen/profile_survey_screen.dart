import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/presentation/screens/profile_survey_screen/widgets/profile_option_select_board.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/automated_opacity_widget.dart';
import 'package:mobile_app/app/presentation/widgets/bottom_chatting_form.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

// ignore: unused_import
import 'profile_survey_screen_controller.dart';

class ProfileSurveyScreen extends GetView<ProfileSurveyScreenController> {
  const ProfileSurveyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChattingRoomAppBar(title: "SNEK"),
      backgroundColor: MyColor.purple,
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          color: Color(0xffF2E2F3),
        ),
        child: Obx(
          () => ListView.separated(
            controller: controller.scrollCon,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemBuilder: (context, index) {
              final chatData = controller.chatTextList[index];
              late (String, SenderType) priorChatData;
              if (index>0) {
                priorChatData = controller.chatTextList[index - 1];
              }
              return AutomatedOpacityWidget(
                duration: const Duration(milliseconds: 400),
                child: ChatMessage(
                  text: chatData.$1,
                  senderType: chatData.$2,
                  sameSenderWithBeforeMessage: index==0?false : priorChatData.$2 == chatData.$2,
                ),
              ).paddingOnly(bottom: controller.chatTextList.length-1 ==index?240:0);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemCount: controller.chatTextList.length,
          ),
        ),
      ),
      bottomSheet: Obx(()=>
        ProfileOptionSelectBoard(
          active: controller.openKeywordBoard.value,
          keywords: controller.getCurrentQuestionOptions,
          onKeywordTap: controller.onKeywordTap,
          child: BottomChattingForm(
            textEditingController: controller.chattingCon,
            onPressed: controller.enableSendButton.value? controller.onSendButtonTap: null,
            hintText: "선택 완료 시 우측 보내기 버튼 클릭",
            context: context,
          ),
        ),
      ),
    );
  }
}
