import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/text_form_fields.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

class BottomChattingForm extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? hintText;
  final VoidCallback? onPressed;
  final BuildContext context;
  const BottomChattingForm({
    super.key,
    required this.textEditingController,
    required this.onPressed,
    this.hintText,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final bottomDevicePadding = MediaQuery.of(this.context).padding.bottom;
    return Container(
      padding: const EdgeInsets.all(16).copyWith(bottom: 16 + bottomDevicePadding/2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Expanded(
            child: MainTextFormField(
              textEditingController: textEditingController,
              hintText: hintText,
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: onPressed,
            icon: Image.asset(
              'assets/images/send_icon.png',
              width: 20,
              height: 20,
            ),
            style: IconButton.styleFrom(
              fixedSize: const Size(37, 37),
              backgroundColor: MyColor.purple,
              disabledBackgroundColor: const Color(0xffd3d3d3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )
            ),
          )
        ],
      ),
    );
  }
}
