import 'package:flutter/material.dart';

class AutomatedOpacityWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const AutomatedOpacityWidget({
    super.key,
    required this.child,
    required this.duration,
  });

  @override
  State<AutomatedOpacityWidget> createState() => _AutomatedOpacityWidgetState();
}

class _AutomatedOpacityWidgetState extends State<AutomatedOpacityWidget> {
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      setState(() {
        opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: widget.duration,
      child: widget.child,
    );
  }
}
