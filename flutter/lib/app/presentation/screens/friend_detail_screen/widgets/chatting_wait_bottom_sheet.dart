import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

class ChattingWaitBottomSheet extends StatelessWidget {
  final VoidCallback onConfirmButtonTap;

  const ChattingWaitBottomSheet({
    Key? key,
    required this.onConfirmButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "상대방의 채팅 수락을\n대기하는 중이에요".tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: MyColor.textBaseColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "상대방이 채팅 요청을 수락할 때까지\n조금만 기다려 주세요 :)".tr,
            style: TextStyle(color: MyColor.textBaseColor.withOpacity(0.8), fontSize: 14),
          ),
          const SizedBox(height: 32),
          MainButton(
            mainButtonType: MainButtonType.key,
            text: '다른 친구들 더 확인하기'.tr,
            onPressed: onConfirmButtonTap,
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom/2),
        ],
      ),
    );
  }
}
