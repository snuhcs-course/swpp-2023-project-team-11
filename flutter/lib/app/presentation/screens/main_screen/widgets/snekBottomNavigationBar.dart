import 'package:flutter/material.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

class SnekBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  late List<BottomNavigationBarItem> items;
  final ValueChanged<int> onTap;

  SnekBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    items = [
      BottomNavigationBarItem(
        icon: Icon(
          Icons.people_rounded,
          color: (currentIndex == 0) ? MyColor.orange_1 : Colors.black.withOpacity(0.4),
        ),
        label: "0",
      ),
      BottomNavigationBarItem(
          icon: (currentIndex == 1)
              ? Image.asset("assets/images/chat-round-dots_filled.png", height: 24)
              : Image.asset("assets/images/chat-round-dots.png", height: 24),
          label: "1"),
      BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            color: (currentIndex == 2) ? MyColor.orange_1 : Colors.black.withOpacity(0.4),
          ),
          label: "2"),
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 84, vertical: 16).copyWith(
        bottom: 16 + MediaQuery.of(context).padding.bottom / 2,
      ),
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: items.asMap().entries
            .map(
              (item) => GestureDetector(
                onTap: () => onTap.call(int.parse(item.value.label!)),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  key: ValueKey(item.key),
                  child: item.value.icon,

                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
