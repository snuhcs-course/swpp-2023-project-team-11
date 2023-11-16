import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  ChatMessage({
    super.key,
    required this.text,
    required this.senderType,
    required this.sameSenderWithBeforeMessage,
    this.onDelete,
    this.tempProxy = false,
    this.needsDelete = false,
    this.senderEmail
  });

  bool get _alignLeft => senderType != SenderType.me;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: _alignLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (_alignLeft && !sameSenderWithBeforeMessage)
        CircleAvatar(
          backgroundImage: (senderType == SenderType.sneki)? const AssetImage('assets/images/sneki_profile.png') : ProfilePic.call(senderEmail!),
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
              if (onDelete!=null){
                onDelete!();
              }
            },
            child: const Icon(
              Icons.delete_forever_sharp,
              size: 16,
              color: MyColor.orange_1,
            ).paddingOnly(right: 6, top: 12),
          ),
        Container(
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
