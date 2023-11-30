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
          _alignLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (_alignLeft && !sameSenderWithBeforeMessage)
          CircleAvatar(
            backgroundImage: (senderType == SenderType.sneki)
                ? const AssetImage('assets/images/sneki_profile.png')
                : ProfilePic.call(senderEmail!),
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
        if (needsDelete)
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
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MyColor.orange_1.withOpacity(0.9),
                ),
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  // roadmap message format:
                  // ex) "ROADMAP_MESSAGE!Discuss worst movies or dramas"
                  // ex) "ROADMAP_MESSAGE!사회 이슈에 대한 토론" - 영어 한국어 둘 다 와야하는데
                  // - 어차피 유저 설정에 따라서 로드맵 추천으로 나오는 언어가 바뀌는게 나을것같아서 필요할 듯
                  "${text.replaceFirst(roadmap_prefix, '')}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(45, 58, 69, 0.9),
                    // fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.left,
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: tempProxy ? Colors.white54 : Colors.white,
                ),
                constraints: const BoxConstraints(maxWidth: 230),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(45, 58, 69, 0.8),
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
