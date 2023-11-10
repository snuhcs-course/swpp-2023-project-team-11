import 'package:flutter/material.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

class MainButton extends StatelessWidget {
  final MainButtonType mainButtonType;
  final String text;
  final void Function()? onPressed;
  final Size? fixedSize;

  const MainButton({
    super.key,
    required this.mainButtonType,
    required this.text,
    required this.onPressed,
    this.fixedSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: mainButtonType.buttonColor,
        disabledBackgroundColor: const Color(0xffd3d3d3),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: fixedSize ?? const Size(double.infinity, 52),
        fixedSize: fixedSize,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: mainButtonType.textColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

enum MainButtonType {
  key(Color(0xffff733d), Colors.white),
  light(Color(0xfff8f1fb), Color.fromRGBO(45, 58, 69, 0.8));

  final Color buttonColor;
  final Color textColor;

  const MainButtonType(this.buttonColor, this.textColor);
}

class SmallButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;

  const SmallButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final Color buttonColor = const Color(0xffff9162);
  final Color textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor: const Color(0xffd3d3d3),
          padding: const EdgeInsets.symmetric(
            horizontal: 11.5,
            vertical: 13,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(90, 0)),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class ExtraSmallButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;

  const ExtraSmallButton({
    required this.onPressed,
    required this.text,
  });

  final Color buttonColor = const Color(0xffff9162);
  final Color textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor: const Color(0xffd3d3d3),
          padding: const EdgeInsets.all(6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(90, 0)),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class BottomNextButton extends StatelessWidget {
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 24).copyWith(
        bottom: MediaQuery.of(context).padding.bottom / 2 + 24,
      ),
      child: MainButton(
          mainButtonType: MainButtonType.key, text: '다음', onPressed: onPressed),
    );
  }

  const BottomNextButton({super.key, this.onPressed});
}

class BottomSnekiButton extends StatelessWidget {
  final void Function()? onPressed;
  final String toBeDisplayed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 24).copyWith(
        bottom: MediaQuery.of(context).padding.bottom / 2 + 24,
      ),
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [MyColor.purple, Colors.transparent,],
      //     begin: Alignment.bottomCenter,
      //     end: Alignment.center
      //   )
      // ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/sneki_holding_here.png",
            scale: 2.2,
          ),
          MainButton(
              mainButtonType: MainButtonType.key,
              text: toBeDisplayed,
              onPressed: onPressed),
        ],
      ),
    );
  }

  const BottomSnekiButton(
      {super.key, this.onPressed, required this.toBeDisplayed});
}
