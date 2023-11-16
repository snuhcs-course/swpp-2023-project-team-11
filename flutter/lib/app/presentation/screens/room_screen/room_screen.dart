import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_controller.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/bottom_chatting_form.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              itemBuilder: (context, index) {
                final chatVm = controller.validChattingRoomController.chatVmList[index];
                late final ChatVM priorChatVm;
                if (index>0) {
                  priorChatVm = controller.validChattingRoomController.chatVmList[index-1];
                }
                return ChatMessage(
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
                  sameSenderWithBeforeMessage: index==0?false : priorChatVm.senderType == chatVm.senderType,
                ).paddingOnly(bottom: controller.validChattingRoomController.chatVmList.length-1 ==index?120:0);
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
              hintText: "선택 완료 시 우측 보내기 버튼 클릭",
              context: context,
              focusNode: controller.chattingFocusNode,
            ),
        ),
      ),
    );
  }
}


