import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_controller.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/bottom_chatting_form.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';
import 'package:mobile_app/core/constants/system_strings.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:mobile_app/core/utils/string_parser_util.dart';

// ignore: unused_import
import 'room_screen_controller.dart';

class RoomScreen extends GetView<RoomScreenController> {
  const RoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: ChattingRoomAppBar(title: controller.chattingRoomTitle,
        additionalAction: IconButton(
          icon: Image.asset("assets/images/sneki_holding_here.png"),
          onPressed: controller.onSnekiTap,
          key: const ValueKey("roadMap"),
        ),
        ),
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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
              itemBuilder: (context, index) {
                final chatVm = controller.validChattingRoomController.chatVmList[index];
                late final ChatVM priorChatVm;
                if (index>0) {
                  priorChatVm = controller.validChattingRoomController.chatVmList[index-1];
                }
                if(chatVm.text.startsWith(roadmap_prefix)){
                  // is a roadmap suggestion chat
                  return ChatMessage(
                    text: StringParserUtil.buildRoadmapText(chatVm.text), // parse adequately
                    senderType: SenderType.sneki,
                    key: ValueKey(chatVm.sequenceId),
                    // tempProxy: chatVm.temp,
                    // needsDelete: chatVm.needsDelete,
                    isRoadmapChat: true,
                    onDelete: () {
                      print(chatVm.sequenceId);
                      print("try delete");
                      controller.onChatDeleteButtonTap(chatVm.sequenceId);
                    },
                    sameSenderWithBeforeMessage: index==0?false : priorChatVm.senderType == SenderType.sneki,
                  ).paddingOnly(bottom: controller.validChattingRoomController.chatVmList.length-1 ==index?120:0);
                } else{
                  return Padding(
                    padding: EdgeInsets.only(left: chatVm.senderType == SenderType.me ? 0: 16, right: chatVm.senderType == SenderType.me ? 16: 0),
                    child: ChatMessage(
                      text: chatVm.text,
                      senderType: chatVm.senderType,
                      key: ValueKey(chatVm.sequenceId),
                      tempProxy: chatVm.temp,
                      needsDelete: chatVm.needsDelete,
                      onDelete: () {
                        print(chatVm.sequenceId);
                        print("try delete");
                        controller.onChatDeleteButtonTap(chatVm.sequenceId);
                      },
                      senderEmail: controller.opponentEmail,
                      sameSenderWithBeforeMessage: index==0?false : (!priorChatVm.text.startsWith(roadmap_prefix)) && (priorChatVm.senderType == chatVm.senderType),
                    ).paddingOnly(bottom: controller.validChattingRoomController.chatVmList.length-1 ==index?120:0),
                  );
                }
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemCount: controller.validChattingRoomController.chatVmList.length,
            ),
          ),
        ),
        bottomSheet: Obx(()=>
            BottomChattingForm(
              textEditingController: controller.chattingCon,
              onPressed: controller.enableSendButton.value? controller.onSendButtonTap: null,
              context: context,
              focusNode: controller.chattingFocusNode,
            ),
        ),
      ),
    );
  }

  
}


