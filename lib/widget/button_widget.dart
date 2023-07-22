import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final Decoration? decoration;
  final Color? color;
  const ButtonWidget({
    super.key,
    this.width,
    this.height,
    this.decoration,
    this.color,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: color,
      decoration: decoration,
      child: TextButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
