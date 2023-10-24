import 'package:flutter/material.dart';

import 'gap_layout.dart';

class BasicDialog extends StatelessWidget {
  final String title;
  final Widget? contentWidget;
  final Widget mainLogicButton;
  final Widget? leftSubButton;

  const BasicDialog({
    super.key,
    required this.title,
    required this.contentWidget,
    required this.mainLogicButton,
    this.leftSubButton,
  });

  @override
  Widget build(BuildContext context) {
    final bool onlyOneButton = leftSubButton == null;
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: GapColumn(
            gap: 18,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              if(contentWidget != null)
              contentWidget!,
              onlyOneButton
                  ? mainLogicButton
                  : GapRow(
                      gap: 18,
                      children: [
                        Expanded(child: leftSubButton!),
                        Expanded(child: mainLogicButton),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
