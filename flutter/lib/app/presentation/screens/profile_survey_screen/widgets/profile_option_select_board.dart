import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

class ProfileOptionSelectBoard extends StatefulWidget {
  final Widget child;
  final bool active;
  final List<Enum> keywords;
  final void Function(List<Enum> keywords) onKeywordTap;

  const ProfileOptionSelectBoard({
    super.key,
    required this.child,
    required this.active,
    required this.keywords,
    required this.onKeywordTap,
  });

  @override
  State<ProfileOptionSelectBoard> createState() => _ProfileOptionSelectBoardState();
}

class _ProfileOptionSelectBoardState extends State<ProfileOptionSelectBoard> {
  final List<Enum> selectedEnums = [];
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.active;
  }


  @override
  void didUpdateWidget(covariant ProfileOptionSelectBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (isActive!= widget.active) {
      isActive = widget.active;
      if (widget.active) {
        selectedEnums.clear();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: widget.active ? 92 : 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 22),
                  const Text(
                    '키워드를 선택해주세요',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(45, 58, 69, 0.8),
                    ),
                  ).paddingOnly(left: 20, bottom: 8),
                  SizedBox(
                    height: 35,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final targetEnum = widget.keywords[index];
                        final isSelected = selectedEnums.contains(targetEnum);
                        return Align(
                          child: GestureDetector(
                            onTap: () {
                              if (isSelected) {
                                setState(() {
                                  selectedEnums.remove(targetEnum);
                                });
                              } else {
                                setState(() {
                                  selectedEnums.add(targetEnum);
                                });
                              }
                              widget.onKeywordTap(selectedEnums);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: isSelected?MyColor.orange_1:Colors.black.withOpacity(0.1), width: 1)),
                              padding: EdgeInsets.all(6),
                              child: Text(
                                widget.keywords[index].toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected?FontWeight.bold:FontWeight.w500,
                                  color: isSelected?MyColor.orange_1:MyColor.textBaseColor,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: 8);
                      },
                      itemCount: widget.keywords.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}
