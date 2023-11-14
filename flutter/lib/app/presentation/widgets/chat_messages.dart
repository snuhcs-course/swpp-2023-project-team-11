import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final SenderType senderType;
  final bool sameSenderWithBeforeMessage;
  final bool tempProxy;
  final bool needsDelete;
  void Function()? onDelete;

  ChatMessage({
    super.key,
    required this.text,
    required this.senderType,
    required this.sameSenderWithBeforeMessage,
    this.onDelete,
    this.tempProxy = false,
    this.needsDelete = false,
  });

  bool get _alignLeft => senderType != SenderType.me;

  bool get needsProfileImg => senderType != SenderType.me && !sameSenderWithBeforeMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: _alignLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (needsProfileImg)
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/sneki_profile.png'),
            radius: 18.5,
          ),
        if (_alignLeft && sameSenderWithBeforeMessage)
          const CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 18.5,
          ),
        const SizedBox(width: 8),
        if (tempProxy && !needsDelete)
          Icon(
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
            child: Icon(
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
