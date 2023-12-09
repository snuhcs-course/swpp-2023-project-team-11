import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/presentation/widgets/basic_dialog.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';

class CompleteDialog extends StatelessWidget {
  final void Function() onSubmit;

  const CompleteDialog({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return BasicDialog(
        title: '프로필 작성 완료'.tr,
        contentWidget: const SizedBox.shrink(),
        mainLogicButton: MainButton(
          mainButtonType: MainButtonType.light,
          text: "제출하기".tr,
          onPressed: onSubmit,
        ));
  }
}
