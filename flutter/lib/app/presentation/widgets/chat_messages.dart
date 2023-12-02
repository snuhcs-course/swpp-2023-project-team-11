import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/core/constants/system_strings.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:mobile_app/app/presentation/widgets/profile_pic_provider.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final SenderType senderType;
  final bool sameSenderWithBeforeMessage;
  final bool tempProxy;
  final bool needsDelete;
  void Function()? onDelete;
  final String? senderEmail;
  final bool isRoadmapChat;

  ChatMessage(
      {super.key,
      required this.text,
      required this.senderType,
      required this.sameSenderWithBeforeMessage,
      this.onDelete,
      this.tempProxy = false,
      this.needsDelete = false,
      this.senderEmail,
      this.isRoadmapChat = false});

  bool get _alignLeft => senderType != SenderType.me;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
          _alignLeft && senderType != SenderType.sneki? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (_alignLeft && !sameSenderWithBeforeMessage && senderType != SenderType.sneki)
          CircleAvatar(
            backgroundImage: ProfilePic.call(senderEmail!),
            radius: 18.5,
          ),
        if (_alignLeft && sameSenderWithBeforeMessage)
          const CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 18.5,
          ),
        const SizedBox(width: 8),
        if (tempProxy && !needsDelete)
          const Icon(
            Icons.arrow_circle_left_sharp,
            size: 16,
            color: MyColor.purple,
          ).paddingOnly(right: 6, top: 12),
        if (tempProxy && needsDelete)
          GestureDetector(
            onTap: () {
              if (onDelete != null) {
                onDelete!();
              }
            },
            child: const Icon(
              Icons.delete_forever_sharp,
              size: 16,
              color: MyColor.orange_1,
            ).paddingOnly(right: 6, top: 12),
          ),
        isRoadmapChat
            ? Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.only(top: 16, left: 20, right: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                gradient: LinearGradient(
                    stops: [0.015, 0.015],
                    colors: [MyColor.orange_1, Colors.white]
                ),

                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  )
                ]
            ),
            constraints: const BoxConstraints(maxWidth: 330),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sneki의 추천이 도착했어요!'.tr, style: TextStyle(color: MyColor.textBaseColor, fontSize: 14, fontWeight: FontWeight.w600)),
                Text('다음 주제에 대해 이야기해보는거 어때요:  '.tr, style: TextStyle(color: MyColor.textBaseColor.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w400)),
                Divider(color: Colors.black.withOpacity(0.1), thickness: 1),
                Text(
                  // roadmap message format:
                  // ex) "ROADMAP_MESSAGE!Discuss worst movies or dramas"
                  // ex) "ROADMAP_MESSAGE!사회 이슈에 대한 토론" - 영어 한국어 둘 다 와야하는데
                  // - 어차피 유저 설정에 따라서 로드맵 추천으로 나오는 언어가 바뀌는게 나을것같아서 필요할 듯
                  "${text}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: MyColor.orange_1,
                    fontWeight: FontWeight.w700
                  ),
                  textAlign: TextAlign.left,
                ),
                Center(
                  child: Image.asset(
                    "assets/images/sneki_holding_here.png",
                    scale: 1.8,
                  ),
                ),
              ],
            ),
          )
            : Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: (senderType == SenderType.me)? (tempProxy ? Color(0xffb085e3) : MyColor.purple) :( tempProxy ? Colors.white54 : Colors.white),
                ),
                constraints: const BoxConstraints(maxWidth: 230),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: (senderType == SenderType.me)? Colors.white : Color.fromRGBO(45, 58, 69, 0.8),
                  ),
                  textAlign: TextAlign.left,
                ),
              )
      ],
    );
  }
}

enum SenderType {
  me,
  you,
  sneki,
}
