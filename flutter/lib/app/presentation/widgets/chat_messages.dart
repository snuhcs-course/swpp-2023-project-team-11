import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final SenderType senderType;
  final bool sameSenderWithBeforeMessage;

  const ChatMessage({
    super.key,
    required this.text,
    required this.senderType,
    required this.sameSenderWithBeforeMessage,
  });

  bool get _alignLeft => senderType != SenderType.me;
  bool get needsProfileImg => senderType!=SenderType.me && !sameSenderWithBeforeMessage;

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
          const CircleAvatar(backgroundColor: Colors.transparent, radius: 18.5,),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          constraints: const BoxConstraints(
            maxWidth: 230
          ),
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
