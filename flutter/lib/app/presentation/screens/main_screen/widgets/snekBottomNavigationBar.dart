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
      BottomNavigationBarItem(icon: (currentIndex == 0)? Image.asset("assets/images/home_filled.png", height: 24):Image.asset("assets/images/home.png", height: 24), label: "0"),
      BottomNavigationBarItem(icon: (currentIndex == 1)? Image.asset("assets/images/chat-round-dots_filled.png", height: 24):Image.asset("assets/images/chat-round-dots.png", height: 24), label: "1"),
      BottomNavigationBarItem(icon: Icon(Icons.person, color: (currentIndex == 2)? MyColor.orange_1: Colors.black.withOpacity(0.4),), label: "2"),
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 84, vertical: 16),
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
        children: items
            .map(
              (item) => GestureDetector(
            onTap: () => onTap.call(int.parse(item.label!)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: item.icon,
            )
            // child: AnimatedSize(
            //   duration: const Duration(milliseconds: 900),
            //   child: Icon(
            //     icon.icon,
            //     size: currentIcon == icon.id ? 26 : 23,
            //     color: currentIcon == icon.id ? primaryColor : Colors.black,
            //   ),
            // ),
          ),
        )
            .toList(),
      ),
    );
  }
}


//
// import 'package:flutter/material.dart';
//
// class SnekBottomNaviagtionBar extends StatefulWidget {
//
//   final void Function(int) onTap;
//   final int currIndex;
//   final List<BottomNavigationBarItem> items;
//
//   @override
//   State<SnekBottomNaviagtionBar> createState() => _SnekBottomNaviagtionBarState();
//
//   const SnekBottomNaviagtionBar({
//     required this.onTap,
//     this.currIndex = 0, required this.items,
//   });
// }
//
// class _SnekBottomNaviagtionBarState extends State<SnekBottomNaviagtionBar>{
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
//       color: Colors.white,
//       child: Row(
//         children: [
//
//
//         ],
//       ),
//     )
//   }
//
// }
//
// IconButton(
// icon: Image.asset("assets/images/sneki_holding_here.png"),
// onPressed: controller.onSnekiTap,
//
// ),
//
// //class Bird extends StatefulWidget {
// //   const Bird({
// //     super.key,
// //     this.color = const Color(0xFFFFE306),
// //     this.child,
// //   });
// //
// //   final Color color;
// //   final Widget? child;
// //
// //   @override
// //   State<Bird> createState() => _BirdState();
// // }
// //
// // class _BirdState extends State<Bird> {
// //   double _size = 1.0;
// //
// //   void grow() {
// //     setState(() { _size += 0.1; });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       color: widget.color,
// //       transform: Matrix4.diagonal3Values(_size, _size, 1.0),
// //       child: widget.child,
// //     );
// //   }
// // }
//
//
// // BottomNavigationBar(
// //           onTap: (index) {
// //             controller.currentIndex(index);
// //           },
// //           currentIndex: controller.currentIndex.value,
// //           items: const [
// //             BottomNavigationBarItem(
// //               icon: Icon(Icons.abc),
// //               label: "0",
// //             ),
// //             BottomNavigationBarItem(icon: Icon(Icons.abc), label: "1"),
// //             BottomNavigationBarItem(icon: Icon(Icons.abc), label: "2"),
// //           ],
// //         ),