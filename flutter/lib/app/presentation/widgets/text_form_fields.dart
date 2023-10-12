import 'package:flutter/material.dart';

class MainTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? hintText;
  final String? titleText;

  const MainTextFormField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    if (titleText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            titleText!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(45, 58, 69, 0.8),
            ),
          ),
          const SizedBox(height: 8),
          _buildTextForm(),
        ],
      );
    }
    return _buildTextForm();
  }

  Widget _buildTextForm() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Color(0xfff2e2f3),
      ),
    );
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xfff8f1fb),
        border: border,
        enabledBorder: border,
        errorBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        hintText: hintText,
      ),
    );
  }
}
